Class {
	#name : 'OModelTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
OModelTest >> testFullNameWithTag [ 

    | model |
    model := OCodeLlamaModel b7.
    self assert: model fullName equals: 'codellama:7b'.
]

{ #category : 'tests' }
OModelTest >> testFullNameWithoutTag [ 

    | model |
    model := OLlamaModel new.
    self assert: model fullName equals: 'llama3'.
]
