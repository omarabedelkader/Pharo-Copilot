"
Mock
"
Class {
	#name : 'OllamaClientStub',
	#superclass : 'Object',
	#instVars : [
		'response',
		'responseBlock',
		'callCount',
		'lastRequestedModel',
		'modelsResponse',
		'pullBlock',
		'pullCount',
		'lastPulledModel',
		'modelsResponses'
	],
	#category : 'AI-Pharo-Copilot-Tests-Mock',
	#package : 'AI-Pharo-Copilot-Tests',
	#tag : 'Mock'
}

{ #category : 'accessing' }
OllamaClientStub >> callCount [ 
    ^ callCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OllamaClientStub >> defaultModelsResponse [

	        ^ Dictionary new
                  at: #models put: { (Dictionary new
                                   at: #name put: (CopilotSettings modelName ifNil: [OTestModelSupport mockModelName ]);
                                   yourself) };
                  yourself
]

{ #category : 'accessing' }
OllamaClientStub >> generateForPrefix: prefixString suffix: suffixString contextDetails: contextDetails [

    callCount := self callCount + 1.
    ^ response ifNil: [ Dictionary new at: #response put: ''; yourself ] ifNotNil: [ response ]
]

{ #category : 'accessing' }
OllamaClientStub >> lastPulledModel [

    ^ lastPulledModel
]

{ #category : 'accessing' }
OllamaClientStub >> lastRequestedModel [
    ^ lastRequestedModel
]

{ #category : 'accessing' }
OllamaClientStub >> listModels [
(modelsResponses notNil and: [ modelsResponses isEmpty not ]) ifTrue: [
        ^ modelsResponses removeFirst
    ].
	^ modelsResponse ifNil: [ self defaultModelsResponse ]
]

{ #category : 'accessing' }
OllamaClientStub >> pullCount [

    ^ pullCount ifNil: [ 0 ]
]

{ #category : 'accessing' }
OllamaClientStub >> pullModelNamed: aModelName [

    lastPulledModel := aModelName.
    pullCount := self pullCount + 1.
    pullBlock ifNotNil: [ ^ pullBlock value: aModelName ].
    ^ Dictionary new
        at: #status put: 'ok';
        yourself
]

{ #category : 'accessing' }
OllamaClientStub >> showModelNamed: aModelName [
    lastRequestedModel := aModelName.
    callCount := self callCount + 1.
    responseBlock ifNotNil: [ ^ responseBlock value: aModelName ].
    ^ response
]

{ #category : 'accessing' }
OllamaClientStub >> withModelsResponse: anObject [

	modelsResponse := anObject.
modelsResponses := nil.
    ^ self
]

{ #category : 'accessing' }
OllamaClientStub >> withModelsResponses: aCollection [
    modelsResponses := OrderedCollection withAll: aCollection.
    modelsResponse := nil.
^self
]

{ #category : 'accessing' }
OllamaClientStub >> withPullBlock: aBlockClosure [

    pullBlock := aBlockClosure.
    ^ self
]

{ #category : 'accessing' }
OllamaClientStub >> withResponse: anObject [
    response := anObject.
    responseBlock := nil.
    ^ self
]

{ #category : 'accessing' }
OllamaClientStub >> withResponseBlock: aBlockClosure [
    responseBlock := aBlockClosure.
    response := nil.
    ^ self
]
