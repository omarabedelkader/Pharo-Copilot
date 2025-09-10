Class {
	#name : 'OModelTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
OModelTest >> testFullNameUpdatesWhenTagSet [

    | model |
    model := OLlamaModel new.
    model tag: 'foo'.
    self assert: model fullName equals: 'llama3:foo'.
]

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

{ #category : 'tests' }
OModelTest >> testFullNameWithoutTagAfterClearing [

    | model |
    model := OCodeLlamaModel b7.
    model tag: nil.
    self assert: model fullName equals: 'codellama'.
]

{ #category : 'tests' }
OModelTest >> testTagAccessor [

    | model |
    model := OLlamaModel new.
    model tag: '1b'.
    self assert: model tag equals: '1b'.
]
