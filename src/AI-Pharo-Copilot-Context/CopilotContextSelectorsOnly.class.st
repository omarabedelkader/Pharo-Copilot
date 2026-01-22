Class {
	#name : 'CopilotContextSelectorsOnly',
	#superclass : 'CopilotContextStrategy',
	#category : 'AI-Pharo-Copilot-Context',
	#package : 'AI-Pharo-Copilot-Context'
}

{ #category : 'hooks' }
CopilotContextSelectorsOnly >> methodsFor: aClass [

	^ aClass selectors asSortedCollection
]

{ #category : 'hooks' }
CopilotContextSelectorsOnly >> renderMethod: aSelector [

	^ aSelector asString
]
