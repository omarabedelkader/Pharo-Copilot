Class {
	#name : 'CopilotContextFullSource',
	#superclass : 'Object',
	#category : 'AI-Pharo-Copilot-Context',
	#package : 'AI-Pharo-Copilot-Context'
}

{ #category : 'hooks' }
CopilotContextFullSource >> methodsFor: aClass [

	^ aClass methodDictionary values
]

{ #category : 'hooks' }
CopilotContextFullSource >> renderMethod: aCompiledMethod [ 

	^ aCompiledMethod sourceCode
]
