Class {
	#name : 'CopilotSettingsTest',
	#superclass : 'TestCase',
	#category : 'AI-Pharo-Copilot-Tests',
	#package : 'AI-Pharo-Copilot-Tests'
}

{ #category : 'tests' }
CopilotSettingsTest >> testAvailableModelName [
    | domain |
    domain := CopilotSettings availableModelNames.
    self assert: domain size > 0.
    self assert: (domain anySatisfy: [:assoc | assoc key = 'Code Llama 7B' and: [assoc value = 'codellama:7b']]).
]
