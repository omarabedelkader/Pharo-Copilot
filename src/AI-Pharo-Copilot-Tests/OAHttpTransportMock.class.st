Class {
	#name : 'OAHttpTransportMock',
	#superclass : 'Object',
	#instVars : [
		'lastPath',
		'lastBody'
	],
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'accessing' }
OAHttpTransportMock >> getJsonAt: aPath [
    lastPath := aPath.
    ^ Dictionary new
]

{ #category : 'accessing' }
OAHttpTransportMock >> lastBody [
    ^ lastBody
]

{ #category : 'accessing' }
OAHttpTransportMock >> lastPath [
    ^ lastPath
]

{ #category : 'accessing' }
OAHttpTransportMock >> postJsonAt: aPath body: aDictionary [
    lastPath := aPath.
    lastBody := aDictionary.
    ^ Dictionary new
]
