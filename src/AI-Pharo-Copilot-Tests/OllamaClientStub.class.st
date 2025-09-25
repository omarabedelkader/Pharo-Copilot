Class {
	#name : 'OllamaClientStub',
	#superclass : 'Object',
	#instVars : [
		'response',
		'responseBlock',
		'callCount',
		'lastRequestedModel'
	],
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'accessing' }
OllamaClientStub >> callCount [ 
    ^ callCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OllamaClientStub >> lastRequestedModel [
    ^ lastRequestedModel
]

{ #category : 'accessing' }
OllamaClientStub >> showModelNamed: aModelName [
    lastRequestedModel := aModelName.
    callCount := self callCount + 1.
    responseBlock ifNotNil: [ ^ responseBlock value: aModelName ].
    ^ response
]

{ #category : 'accessing' }
OllamaClientStub >> withResponse: anObject [
    response := anObject.
    responseBlock := nil.
    ^ self
]

{ #category : 'accessing' }
OllamaClientStub >> withResponseBlock: aBlockClosure [
    responseBlock := aBlockClosure.
    response := nil.
    ^ self
]
