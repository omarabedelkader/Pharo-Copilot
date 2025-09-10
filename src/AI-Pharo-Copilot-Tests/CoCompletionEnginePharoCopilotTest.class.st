Class {
	#name : 'CoCompletionEnginePharoCopilotTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
CoCompletionEnginePharoCopilotTest >> testCompletionBuilderHasNilContext [

    | engine builder |
    engine := CoCompletionEnginePharoCopilot new.
    builder := engine completionBuilder.
    self assert: builder completionContext isNil.
]

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

{ #category : 'tests' }
CoCompletionEnginePharoCopilotTest >> testDifferentEnginesHaveDifferentBuilders [

    | engine1 engine2 builder1 builder2 |
    engine1 := CoCompletionEnginePharoCopilot new.
    engine2 := CoCompletionEnginePharoCopilot new.
    builder1 := engine1 completionBuilder.
    builder2 := engine2 completionBuilder.
    self deny: builder1 identicalTo: builder2.
]
