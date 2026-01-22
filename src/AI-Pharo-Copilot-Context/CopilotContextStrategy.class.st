Class {
	#name : 'CopilotContextStrategy',
	#superclass : 'Object',
	#category : 'AI-Pharo-Copilot-Context',
	#package : 'AI-Pharo-Copilot-Context'
}

{ #category : 'hooks' }
CopilotContextStrategy >> methodsFor: aClass [

	self subclassResponsibility
]

{ #category : 'hooks' }
CopilotContextStrategy >> renderMethod: aCompiledMethod [

	self subclassResponsibility
]
