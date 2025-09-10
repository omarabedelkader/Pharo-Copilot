Class {
	#name : 'OModelSpecTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
OModelSpecTest >> testFamilyAccessor [

    | spec |
    spec := OModelSpec family: 'abc' tag: nil label: 'ABC'.
    self assert: spec family equals: 'abc'.
]

{ #category : 'tests' }
OModelSpecTest >> testFamilySetter [

    | spec |
    spec := OModelSpec family: 'abc' tag: nil label: 'ABC'.
    spec family: 'xyz'.
    self assert: spec family equals: 'xyz'.
]

{ #category : 'tests' }
OModelSpecTest >> testFullNameWithTag [ 

    | spec |
    spec := OModelSpec family: 'foo' tag: 'bar' label: 'Foo Bar'.
    self assert: spec fullName equals: 'foo:bar'.
]

{ #category : 'tests' }
OModelSpecTest >> testFullNameWithoutTag [

    | spec |
    spec := OModelSpec family: 'foo' tag: nil label: 'Foo'.
    self assert: spec fullName equals: 'foo'.
]

{ #category : 'tests' }
OModelSpecTest >> testLabelAccessor [

    | spec |
    spec := OModelSpec family: 'abc' tag: nil label: 'ABC'.
    self assert: spec label equals: 'ABC'.
]

{ #category : 'tests' }
OModelSpecTest >> testLabelSetter [

    | spec |
    spec := OModelSpec family: 'abc' tag: nil label: 'ABC'.
    spec label: 'XYZ'.
    self assert: spec label equals: 'XYZ'.
]

{ #category : 'tests' }
OModelSpecTest >> testTagAccessor [

    | spec |
    spec := OModelSpec family: 'abc' tag: 'def' label: 'ABC'.
    self assert: spec tag equals: 'def'.
]
