"
Mock 
"
Class {
	#name : 'CoCopilotEntryTestContext',
	#superclass : 'Object',
	#instVars : [
		'replacedToken'
	],
	#category : 'AI-Pharo-Copilot-Tests-Mock',
	#package : 'AI-Pharo-Copilot-Tests',
	#tag : 'Mock'
}

{ #category : 'replacement' }
CoCopilotEntryTestContext >> replaceTokenInEditorWith: aString [
    replacedToken := aString
]

{ #category : 'replacement' }
CoCopilotEntryTestContext >> replacedToken [
    ^ replacedToken
]
