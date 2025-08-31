Class {
	#name : 'CoCompletionEnginePharoCopilotTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
CoCompletionEnginePharoCopilotTest >> testCompletionBuilderIsCoPharoCopilotResultSetBuilder [

    | engine builder |
    engine := CoCompletionEnginePharoCopilot new.
    builder := engine completionBuilder.
    self assert: builder class equals: CoPharoCopilotResultSetBuilder.
]

{ #category : 'tests' }
CoCompletionEnginePharoCopilotTest >> testCompletionBuilderMemoization [

	| engine firstBuilder secondBuilder |
	engine := CoCompletionEnginePharoCopilot new.
	firstBuilder := engine completionBuilder.
	secondBuilder := engine completionBuilder.
	self assert: firstBuilder identicalTo: secondBuilder
]
