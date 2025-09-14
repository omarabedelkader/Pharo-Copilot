Class {
	#name : 'CoEvaluationAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'entry'
	],
	#category : 'AI-Pharo-Copilot-Evaluator',
	#package : 'AI-Pharo-Copilot-Evaluator'
}

{ #category : 'settings' }
CoEvaluationAnnouncement class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder setting: #Copilot)
		target: self;
		parentName: #codeBrowsing;
		selector: #copilotEnabled;
		default: true;
		iconName: #smallConfiguration;
		description: 'Enable Copilot inline suggestions and configure its backend.';
		with: [
				"... existing settings ..."
				
				(aBuilder group: #evaluation)
					label: 'Evaluation & Analytics';
					description: 'Configure suggestion evaluation and tracking';
					with: [
						(aBuilder setting: #viewEvaluationReport)
							label: 'View Evaluation Report';
							action: [ CoSuggestionEvaluator default generateReport inspect ];
							description: 'View detailed evaluation statistics'.
							
						(aBuilder setting: #exportEvaluationData)
							label: 'Export Evaluation Data';
							action: [ | filename |
								filename := UIManager default 
									request: 'Enter filename for CSV export:' 
									initialAnswer: 'copilot-evaluation.csv'.
								filename ifNotNil: [
									CoSuggestionEvaluator default exportToCSV: filename.
									UIManager default inform: 'Data exported to ', filename ] ];
							description: 'Export evaluation data to CSV file'.
							
						(aBuilder setting: #resetEvaluationData)
							label: 'Reset Evaluation Data';
							action: [ 
								(UIManager default confirm: 'This will clear all evaluation data. Continue?') 
									ifTrue: [ CoSuggestionEvaluator reset.
										UIManager default inform: 'Evaluation data reset' ] ];
							description: 'Clear all collected evaluation data' ] ]
]

{ #category : 'accessing' }
CoEvaluationAnnouncement >> entry [
	^ entry
]

{ #category : 'accessing' }
CoEvaluationAnnouncement >> entry: anEvaluationEntry [
	entry := anEvaluationEntry
]
