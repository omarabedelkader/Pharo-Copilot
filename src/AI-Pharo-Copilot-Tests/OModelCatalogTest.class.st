Class {
	#name : 'OModelCatalogTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
OModelCatalogTest >> testBuiltInModelPragmas [

        | pragmas uniqueFamiliesAndTags uniqueLabels |
        pragmas := Pragma allNamed: #ollamaModel:tag:label: in: OModelCatalog class.

        self deny: pragmas isEmpty.

        uniqueFamiliesAndTags := (pragmas collect: [ :pragma |
                pragma arguments first -> pragma arguments second ]) asSet.
        uniqueLabels := (pragmas collect: [ :pragma | pragma arguments third ]) asSet.

        self assert: uniqueFamiliesAndTags size equals: pragmas size.
        self assert: uniqueLabels size equals: pragmas size
]

{ #category : 'tests' }
OModelCatalogTest >> testCodeLlamaModelsHaveCorrectStructure [
	| pragmas |
	pragmas := Pragma allNamed: #ollamaModel:tag:label: in: OModelCatalog class.
	
	pragmas do: [ :pragma |
		self assert: pragma arguments size equals: 3.
		self assert: pragma arguments first isString.
		self assert: pragma arguments second isString.
		self assert: pragma arguments third isString ]
]
