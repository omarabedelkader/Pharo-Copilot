Class {
	#name : 'CoEvaluationEntry',
	#superclass : 'Object',
	#instVars : [
		'suggestion',
		'context',
		'timestamp',
		'action',
		'rejectionReason',
		'metadata'
	],
	#category : 'AI-Pharo-Copilot-Evaluator',
	#package : 'AI-Pharo-Copilot-Evaluator'
}

{ #category : 'accessing' }
CoEvaluationEntry >> action [
	^ action
]

{ #category : 'accessing' }
CoEvaluationEntry >> action: aSymbol [ 
	"#accepted, #rejected, or #ignored"
	action := aSymbol
]

{ #category : 'accessing' }
CoEvaluationEntry >> context [
	^ context
]

{ #category : 'accessing' }
CoEvaluationEntry >> context: aCompletionContext [
	context := aCompletionContext
]

{ #category : 'accessing' }
CoEvaluationEntry >> metadata [
	^ metadata ifNil: [ metadata := Dictionary new ]
]

{ #category : 'accessing' }
CoEvaluationEntry >> metadata: aDictionary [
	metadata := aDictionary
]

{ #category : 'accessing' }
CoEvaluationEntry >> rejectionReason [
	^ rejectionReason
]

{ #category : 'accessing' }
CoEvaluationEntry >> rejectionReason: aString [
	rejectionReason := aString
]

{ #category : 'accessing' }
CoEvaluationEntry >> suggestion [ 
	^ suggestion
]

{ #category : 'accessing' }
CoEvaluationEntry >> suggestion: aCopilotEntry [
	suggestion := aCopilotEntry
]

{ #category : 'accessing' }
CoEvaluationEntry >> timestamp [
	^ timestamp
]

{ #category : 'accessing' }
CoEvaluationEntry >> timestamp: aDateAndTime [
	timestamp := aDateAndTime
]
