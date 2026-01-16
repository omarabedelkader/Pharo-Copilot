"
OAHttpTransport is a small HTTP helper that talks to a local Ollama server and
returns Smalltalk objects by sending/receiving JSON over HTTP (GET and POST).
It centralizes host/port, JSON encoding/decoding, and default headers.
"
Class {
	#name : 'OAHttpTransport',
	#superclass : 'Object',
	#instVars : [
		'host',
		'port',
		'defaultHeaders',
		'jsonReader',
		'jsonWriter'
	],
	#category : 'AI-Pharo-Copilot-Ollama',
	#package : 'AI-Pharo-Copilot-Ollama'
}

{ #category : 'private' }
OAHttpTransport >> applyDefaultHeadersTo: aClient [
	"Apply the transport default headers to the given client."

	defaultHeaders keysAndValuesDo: [ :key :value |
		aClient headerAt: key put: value ]
]

{ #category : 'private' }
OAHttpTransport >> configureJsonOn: aClient [
	"Configure JSON accept/content reader/writer on the given client using the transport JSON reader/writer."

	aClient accept: ZnMimeType applicationJson.

	aClient contentWriter: [ :data |
		ZnEntity json: (jsonWriter toString: data) ].

	aClient contentReader: [ :entity |
		jsonReader fromString: entity contents ]
]

{ #category : 'accessing' }
OAHttpTransport >> defaultHeaders [
	"Answer the dictionary of headers applied to every request."

	^ defaultHeaders
]

{ #category : 'accessing' }
OAHttpTransport >> defaultHeaders: aDictionary [
	"Set the dictionary of headers applied to every request."

	defaultHeaders := aDictionary
]

{ #category : 'requests' }
OAHttpTransport >> getJsonAt: aPath [
	"Perform a GET request on the given path and answer the decoded JSON response."

	| client |
	client := self newJsonClientForPath: aPath.
	^ client get
]

{ #category : 'accessing' }
OAHttpTransport >> host [
	"Answer the configured host used for requests."

	^ host
]

{ #category : 'accessing' }
OAHttpTransport >> host: anObject [
	"Set the host used for requests."

	host := anObject
]

{ #category : 'initialization' }
OAHttpTransport >> initialize [
	"Initialize the transport with settings (host/port), JSON reader/writer, and an empty default header set."

	super initialize.
	host := CopilotSettings host.
	port := CopilotSettings port.
	defaultHeaders := Dictionary new.
	jsonReader := ZnUtils defaultJSONReader.
	jsonWriter := ZnUtils defaultJSONWriter
]

{ #category : 'accessing' }
OAHttpTransport >> jsonReader [
	"Answer the JSON reader used to decode responses."

	^ jsonReader
]

{ #category : 'accessing' }
OAHttpTransport >> jsonReader: anObject [
	"Set the JSON reader used to decode responses."

	jsonReader := anObject
]

{ #category : 'accessing' }
OAHttpTransport >> jsonWriter [
	"Answer the JSON writer used to encode request bodies."

	^ jsonWriter
]

{ #category : 'accessing' }
OAHttpTransport >> jsonWriter: anObject [
	"Set the JSON writer used to encode request bodies."

	jsonWriter := anObject
]

{ #category : 'private' }
OAHttpTransport >> newJsonClientForPath: aPath [
	"Create and configure a Zinc client for JSON REST calls using ZnEasy (so tests can replace it)."

	| client |
	client := ZnEasy client.
	client forJsonREST.
	client host: host; port: port; path: aPath.

	"Hard stop so UI never waits forever if Ollama is slow/down."
	(client respondsTo: #timeout:) ifTrue: [ client timeout: 5 ].

	self applyDefaultHeadersTo: client.
	self configureJsonOn: client.

	^ client
]

{ #category : 'accessing' }
OAHttpTransport >> port [
	"Answer the configured port used for requests."

	^ port
]

{ #category : 'accessing' }
OAHttpTransport >> port: anObject [
	"Set the port used for requests."

	port := anObject
]

{ #category : 'requests' }
OAHttpTransport >> postJsonAt: aPath body: aDictionary [
	"Perform a POST request on the given path with the given object as JSON body, answering the decoded JSON response."

	| client |
	client := self newJsonClientForPath: aPath.
	client contents: aDictionary.
	^ client post
]

{ #category : 'requests' }
OAHttpTransport >> postNdjsonAt: aPath body: aDictionary timeoutSeconds: timeoutSeconds onChunk: aBlock [
	"POST JSON and read application/x-ndjson streaming responses line-by-line.
	Important: do NOT use #atEnd for socket streams; read until #nextLine answers nil."

	| client response stream line obj last |

	client := ZnClient new.
	client
		host: host;
		port: port;
		path: aPath.

	(client respondsTo: #timeout:) ifTrue: [ client timeout: timeoutSeconds ].

	"Critical for streaming downloads (otherwise Zinc may buffer the whole response)."
	(client respondsTo: #streaming:) ifTrue: [ client streaming: true ]. 

	self applyDefaultHeadersTo: client.
	client accept: ZnMimeType applicationJson.
	client entity: (ZnEntity json: (jsonWriter toString: aDictionary)).

	client post.
	response := client response.

	"Handle non-2xx right away"
	((response respondsTo: #isSuccess) and: [ response isSuccess not ]) ifTrue: [
		^ Error signal: ('Ollama pull failed (HTTP ', response code asString, '): ', response entity contents) ].

	last := nil.
	stream := response entity readStream.

	[
		[ (line := stream nextLine) notNil ] whileTrue: [
			line := line trimBoth.
			line isEmpty ifTrue: [ "skip" ] ifFalse: [
				obj := [ jsonReader fromString: line ] on: Error do: [ nil ].
				obj ifNotNil: [
					last := obj.

					((obj respondsTo: #at:ifAbsent:) and: [ (obj at: #error ifAbsent: [ obj at: 'error' ifAbsent: [ nil ] ]) notNil ])
						ifTrue: [
							^ Error signal: (obj at: #error ifAbsent: [ obj at: 'error' ifAbsent: [ 'Unknown error' ] ]) ].

					aBlock ifNotNil: [ aBlock value: obj ] ] ] ] ]
	ensure: [
		[ stream close ] on: Error do: [ :ignored | ].
		[ client close ] on: Error do: [ :ignored | ] ].

	^ last

]

{ #category : 'requests' }
OAHttpTransport >> postStreamingJsonAt: aPath body: aDictionary timeoutSeconds: timeoutSeconds do: aBlock [
	"POST JSON and read a newline-delimited stream of JSON objects (NDJSON).
	For each parsed object, evaluate aBlock (if provided). Answer the last parsed object."

	| client response stream line parsed last |
	client := ZnEasy client.
	client host: host; port: port; path: aPath.

	(client respondsTo: #timeout:) ifTrue: [
		timeoutSeconds ifNotNil: [ client timeout: timeoutSeconds ] ].

	self applyDefaultHeadersTo: client.
	client accept: ZnMimeType applicationJson.
	client entity: (ZnEntity json: (jsonWriter toString: aDictionary)).

	client post.
	response := client response.

	last := nil.
	stream := response entity readStream.

	[
		[ stream atEnd ] whileFalse: [
			line := stream nextLine.
			line ifNotNil: [ line := line trimBoth ].

			(line isNil or: [ line isEmpty ]) ifFalse: [
				parsed := [ jsonReader fromString: line ] on: Error do: [ nil ].
				parsed ifNotNil: [
					last := parsed.
					aBlock ifNotNil: [ aBlock value: parsed ] ] ] ] ]
		ensure: [ [ stream close ] on: Error do: [ :ignored | ] ].

	^ last
]
