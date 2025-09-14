Class {
	#name : 'CoEvaluationAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'entry'
	],
	#category : 'AI-Pharo-Copilot-Evaluator',
	#package : 'AI-Pharo-Copilot-Evaluator'
}

{ #category : 'accessing' }
CoEvaluationAnnouncement >> entry [
	^ entry
]

{ #category : 'accessing' }
CoEvaluationAnnouncement >> entry: anEvaluationEntry [
	entry := anEvaluationEntry
]
