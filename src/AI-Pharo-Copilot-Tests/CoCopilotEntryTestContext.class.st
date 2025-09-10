Class {
	#name : 'CoCopilotEntryTestContext',
	#superclass : 'Object',
	#instVars : [
		'replacedToken'
	],
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'replacement' }
CoCopilotEntryTestContext >> replaceTokenInEditorWith: aString [
    replacedToken := aString
]

{ #category : 'replacement' }
CoCopilotEntryTestContext >> replacedToken [
    ^ replacedToken
]
