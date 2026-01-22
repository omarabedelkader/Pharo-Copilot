"
CoCopilotEntry models one completion suggestion produced by Pharo Copilot.
It stores the suggested text, can apply it to a completion context, and provides a short preview for UI display.
"
Class {
	#name : 'CoCopilotEntry',
	#superclass : 'Object',
	#instVars : [
		'text'
	],
	#category : 'AI-Pharo-Copilot',
	#package : 'AI-Pharo-Copilot'
}

{ #category : 'accessing' }
CoCopilotEntry class >> contents: aString [
	"Create a new entry holding the given suggestion text."

	^ self new
		text: aString;
		yourself
]

{ #category : 'actions' }
CoCopilotEntry >> activateOn: aCoCompletionContext [
	"Apply this suggestion by inserting it at the cursor position."

	| editor |
	aCoCompletionContext ifNil: [ Error signal: 'Completion context is nil' ].

	editor := (aCoCompletionContext respondsTo: #editor)
		ifTrue: [ aCoCompletionContext editor ]
		ifFalse: [ nil ].


	"Try to insert at caret (preserves user's text)"
	editor ifNotNil: [
		(editor respondsTo: #addString:) ifTrue: [
			^ editor addString: self contents
		].


		"Fallback: replace selection if empty"
		(editor respondsTo: #selectionInterval) ifTrue: [
			editor selectionInterval isEmpty ifTrue: [
				^ editor replaceSelectionWith: self contents
			]
		]
	].

	"Last resort: use context's replace method"
	(aCoCompletionContext respondsTo: #replaceTokenInEditorWith:) ifTrue: [
		^ aCoCompletionContext replaceTokenInEditorWith: self contents
	]
]

{ #category : 'accessing' }
CoCopilotEntry >> contents [
	"Answer the full suggestion text stored by this entry."

	^ text
]

{ #category : 'displaying' }
CoCopilotEntry >> displayString [
	"Answer a UI-friendly preview (truncated to 120 characters when needed)."

	^ (self contents size > 120)
		ifTrue: [ (self contents copyFrom: 1 to: 117), '…' ]
		ifFalse: [ self contents ]
]

{ #category : 'displaying' }
CoCopilotEntry >> text: aString [
	"Set the suggestion text stored by this entry."

	text := aString
]
