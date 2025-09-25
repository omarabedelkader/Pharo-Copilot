"
Holds global settings for Copilot and its Ollama backend.
"
Class {
	#name : 'CopilotSettings',
	#superclass : 'Object',
	#classInstVars : [
		'Enabled',
		'Provider',
		'ModelName',
		'FimTemplate',
		'Host',
		'Port',
		'FimTemplateOption',
		'CustomFimTemplateFile',
		'ModelMetadata',
		'OllamaClientFactory'
	],
	#category : 'AI-Pharo-Copilot-Ollama',
	#package : 'AI-Pharo-Copilot-Ollama'
}

{ #category : 'accessing' }
CopilotSettings class >> availableFimTemplateOptions [

    ^ {
        'Inline (edit below)' -> #inline.
        'Custom template file' -> #customFile
    }
]

{ #category : 'settings' }
CopilotSettings class >> availableModelNames [

	^ OModelRegistry refresh domainValuesForSettings
]

{ #category : 'settings' }
CopilotSettings class >> availableProviders [

    "Adapt to your backends"
    ^ { #ollama}.
]

{ #category : 'accessing' }
CopilotSettings class >> clearCachedModelMetadata [
    ModelMetadata := nil.
]

{ #category : 'accessing' }
CopilotSettings class >> copilotEnabled [
    ^ Enabled ifNil: [ Enabled := true ].
]

{ #category : 'accessing' }
CopilotSettings class >> copilotEnabled: aBool [

    Enabled := aBool.
]

{ #category : 'accessing' }
CopilotSettings class >> copilotProvider [

    ^ Provider ifNil: [ Provider := #ollama ].
]

{ #category : 'accessing' }
CopilotSettings class >> copilotProvider: aSymbol [

    Provider := aSymbol.
]

{ #category : 'accessing' }
CopilotSettings class >> customFimTemplateFile [

    ^ (CustomFimTemplateFile ifNil: [ CustomFimTemplateFile := self defaultCustomFimTemplateFile ]) asFileReference
]

{ #category : 'accessing' }
CopilotSettings class >> customFimTemplateFile: aFileReferenceOrString [

    CustomFimTemplateFile := aFileReferenceOrString asFileReference.
    ^ CustomFimTemplateFile
]

{ #category : 'accessing' }
CopilotSettings class >> customFimTemplateFilePath [

    ^ self customFimTemplateFile fullName
]

{ #category : 'accessing' }
CopilotSettings class >> customFimTemplateFilePath: aString [

    aString ifNil: [ ^ self ].
    aString isEmpty ifTrue: [ ^ self ].
    self customFimTemplateFile: aString.
    self fimTemplateOption = #customFile ifTrue: [ self ensureCustomFimTemplateFile ].
]

{ #category : 'accessing' }
CopilotSettings class >> customFimTemplateFromFile [

    | file contents |
    file := self ensureCustomFimTemplateFile.
    contents := [ file contents ]
        on: Error
        do: [ ^ FimTemplate ifNil: [ self defaultFimTemplate ] ].
    contents ifNil: [ ^ FimTemplate ifNil: [ self defaultFimTemplate ] ].
    contents isEmpty ifTrue: [ ^ FimTemplate ifNil: [ self defaultFimTemplate ] ].
    ^ contents
]

{ #category : 'accessing' }
CopilotSettings class >> defaultCustomFimTemplateFile [

	^ (self templatesDirectory / 'custom-fim-template.tmpl') asFileReference
]

{ #category : 'accessing' }
CopilotSettings class >> defaultFimTemplate [

	    | file contents |
    file := self ensureDefaultFimTemplateFile.
    contents := [ file contents ] on: Error do: [ ^ self defaultFimTemplateString ].
    (contents isNil or: [ contents isEmpty ]) ifTrue: [ ^ self defaultFimTemplateString ].
    ^ contents
]

{ #category : 'accessing' }
CopilotSettings class >> defaultFimTemplateFile [
    ^ self templatesDirectory / 'inline-fim-template.tmpl'
]

{ #category : 'accessing' }
CopilotSettings class >> defaultFimTemplateString [
    ^ '<PRE>%1<SUF>%2<MID>'
]

{ #category : 'accessing' }
CopilotSettings class >> ensureCustomFimTemplateFile [

	| file |
    file := self customFimTemplateFile.
    [ file parent ensureCreateDirectory ] on: Error do: [ :ignored | ].
    file exists ifFalse: [
	        | initialTemplate |
        initialTemplate := FimTemplate ifNil: [ self defaultFimTemplate ].
        [ file ensureCreateFile ] on: Error do: [ :ignored | ].
        [ file writeStreamDo: [ :stream | stream nextPutAll: initialTemplate ] ] on: Error do: [ :ignored | ].
    ].
    ^ file
]

{ #category : 'accessing' }
CopilotSettings class >> ensureDefaultFimTemplateFile [
    | file |
    file := self defaultFimTemplateFile.
    [ file parent ensureCreateDirectory ] on: Error do: [ :ignored | ].
    file exists ifFalse: [
        [ file ensureCreateFile ] on: Error do: [ :ignored | ].
        [ file writeStreamDo: [ :stream | stream nextPutAll: self defaultFimTemplateString ] ] on: Error do: [ :ignored | ].
    ].
    ^ file
]

{ #category : 'accessing' }
CopilotSettings class >> fetchModelMetadata [
    | client response metadata |
    metadata := Dictionary new.
    [
        client := self newOllamaClient.
        response := client showModelNamed: self modelName.
        response ifNil: [ ^ metadata ].
        self populateMetadata: metadata fromResponse: response.
        CoCopilotLogger
            logBackEndEvent: 'Fetched Ollama model metadata'
            details: (Dictionary new
                at: #model put: (metadata at: #model ifAbsent: [ self modelName ]);
                at: #keys put: metadata keys asArray;
                yourself).
    ] on: Error do: [ :ex |
        CoCopilotLogger
            logBackEndEvent: 'Failed to fetch Ollama model metadata'
            details: (Dictionary new
                at: #model put: self modelName;
                at: #errorClass put: ex class name;
                at: #error put: ex description;
                yourself).
    ].
    ^ metadata
]

{ #category : 'accessing' }
CopilotSettings class >> fimTemplate [

	self fimTemplateOption = #customFile ifTrue: [ ^ self customFimTemplateFromFile ].
    ^ FimTemplate ifNil: [ FimTemplate := self defaultFimTemplate ].
]

{ #category : 'accessing' }
CopilotSettings class >> fimTemplate: aString [

	FimTemplate := aString.
	self fimTemplateOption: #inline.
]

{ #category : 'accessing' }
CopilotSettings class >> fimTemplateOption [

    ^ FimTemplateOption ifNil: [ FimTemplateOption := #inline ].
]

{ #category : 'accessing' }
CopilotSettings class >> fimTemplateOption: aSymbol [

    | normalized |
    normalized := aSymbol ifNil: [ #inline ].
    (normalized isSymbol) ifFalse: [
        (normalized respondsTo: #asSymbol)
            ifTrue: [ normalized := normalized asSymbol ]
            ifFalse: [ normalized := #inline ]
    ].
    (#(#inline #customFile) includes: normalized)
        ifFalse: [ normalized := #inline ].
    FimTemplateOption := normalized.
    normalized = #inline ifTrue: [ FimTemplate ifNil: [ FimTemplate := self defaultFimTemplate ] ].
    normalized = #customFile ifTrue: [ self ensureCustomFimTemplateFile ].
]

{ #category : 'accessing' }
CopilotSettings class >> host [

    ^ Host ifNil: [ Host := '127.0.0.1' ].
]

{ #category : 'accessing' }
CopilotSettings class >> host: aString [

    Host := aString.
self clearCachedModelMetadata.
]

{ #category : 'accessing' }
CopilotSettings class >> isCopilotEngineSelected [
    "Check if the current completion engine is the copilot engine"
    ^ [ 
        | currentEngine |
        currentEngine := RubSmalltalkEditor completionEngineClass.
        currentEngine notNil and: [ 
            currentEngine name = 'CoCompletionEnginePharoCopilot' or: [
                currentEngine name includesSubstring: 'Copilot' ] ]
    ] on: Error do: [ false ]
]

{ #category : 'accessing' }
CopilotSettings class >> metadataStringForKey: aKey default: defaultString [
    | metadata value |
    metadata := self modelMetadata.
    value := metadata
        at: aKey
        ifAbsent: [ metadata at: aKey asString ifAbsent: [ nil ] ].
    value isNil ifTrue: [ ^ defaultString ].
    value isString ifTrue: [ value isEmpty ifTrue: [ ^ defaultString ]. ^ value ].
    (value respondsTo: #asString)
        ifTrue: [ | converted |
            converted := value asString.
            converted isEmpty ifTrue: [ ^ defaultString ].
            ^ converted ].
    [
        | json |
        json := STONJSON toString: value.
        json isEmpty ifTrue: [ ^ defaultString ].
        ^ json
    ] on: Error do: [ :ignored | ].
    ^ value printString
]

{ #category : 'accessing' }
CopilotSettings class >> modelMetadata [
    ModelMetadata ifNil: [ ModelMetadata := self fetchModelMetadata ].
    ^ ModelMetadata
]

{ #category : 'accessing' }
CopilotSettings class >> modelName [

	^ ModelName ifNil: [ ModelName := OllamaClient defaultModelFullName ]
]

{ #category : 'accessing' }
CopilotSettings class >> modelName: aString [

	ModelName := aString.
	self clearCachedModelMetadata.
]

{ #category : 'accessing' }
CopilotSettings class >> modelParameters [
    ^ self metadataStringForKey: #parameters default: 'Not provided by model.'
]

{ #category : 'accessing' }
CopilotSettings class >> modelParameters: ignored [
    "Ignore attempts to set read-only metadata from the settings UI"
]

{ #category : 'accessing' }
CopilotSettings class >> modelSystemPrompt [
    ^ self metadataStringForKey: #system default: 'Not provided by model.'
]

{ #category : 'accessing' }
CopilotSettings class >> modelSystemPrompt: ignored [
    "Ignore attempts to set read-only metadata from the settings UI"
]

{ #category : 'accessing' }
CopilotSettings class >> modelTemplate [
    ^ self metadataStringForKey: #template default: 'Not provided by model.'
]

{ #category : 'accessing' }
CopilotSettings class >> modelTemplate: ignored [
    "Ignore attempts to set read-only metadata from the settings UI"
]

{ #category : 'accessing' }
CopilotSettings class >> newOllamaClient [
    ^ self ollamaClientFactory value
]

{ #category : 'accessing' }
CopilotSettings class >> ollamaClientFactory [
    OllamaClientFactory ifNil: [ OllamaClientFactory := [ OllamaClient new ] ].
    ^ OllamaClientFactory
]

{ #category : 'accessing' }
CopilotSettings class >> ollamaClientFactory: aBlockClosure [
    OllamaClientFactory := aBlockClosure.
    self clearCachedModelMetadata.
]

{ #category : 'accessing' }
CopilotSettings class >> populateMetadata: metadata fromResponse: response [

  | keys details parsedResponse |
    response ifNil: [ ^ metadata ].
    parsedResponse := response.
    parsedResponse isString ifTrue: [
        [ parsedResponse := STONJSON fromString: parsedResponse ] 
            on: Error do: [ ^ metadata ].
    ].
    (parsedResponse respondsTo: #at:ifAbsent:) ifFalse: [ ^ metadata ].
    keys := #(#template #system #parameters #modelfile).
    keys do: [ :key |
        | value altKey |
        altKey := key asString.
        value := parsedResponse at: key ifAbsent: [ parsedResponse at: altKey ifAbsent: [ nil ] ].
        value ifNotNil: [ metadata at: key put: value ].
    ].
    details := parsedResponse at: #details ifAbsent: [ parsedResponse at: 'details' ifAbsent: [ nil ] ].
    details ifNotNil: [ metadata at: #details put: details ].
    metadata at: #model put: (parsedResponse at: #model ifAbsent: [ parsedResponse at: 'model' ifAbsent: [ self modelName ] ]).
    ^ metadata

]

{ #category : 'accessing' }
CopilotSettings class >> port [

    ^ Port ifNil: [ Port := 11434 ].
]

{ #category : 'accessing' }
CopilotSettings class >> port: aNumber [

	Port := aNumber isString
		        ifTrue: [
				        [ aNumber asNumber ]
					        on: Error
					        do: [ self port ] ]
		        ifFalse: [ aNumber ].
		self clearCachedModelMetadata.
]

{ #category : 'settings' }
CopilotSettings class >> settingsOn: aBuilder [
	"Only show copilot settings if copilot engine is selected"

	<systemsettings>
	self isCopilotEngineSelected ifFalse: [ ^ self ].

	(aBuilder setting: #CopilotSettings)
		target: self;
		parentName: #codeBrowsing;
		selector: #copilotEnabled;
		default: true;
		iconName: #smallConfiguration;
		label: 'Copilot';
		description: 'Configure Pharo Copilot AI completion settings.';
		with: [
				(aBuilder pickOne: #provider)
					order: -1;
					label: 'Provider';
					target: self;
					getSelector: #copilotProvider;
					setSelector: #copilotProvider:;
					domainValues: self availableProviders.

				(aBuilder pickOne: #modelName)
					label: 'Model';
					target: self;
					getSelector: #modelName;
					setSelector: #modelName:;
					default: self modelName;
					domainValues: self availableModelNames.

				(aBuilder setting: #modelTemplate)
					order: 0.5;
					label: 'Model template (read only)';
					target: self;
					getSelector: #modelTemplate;
					setSelector: #modelTemplate:;
					default: self modelTemplate;
					description: 'Template provided by the selected Ollama model. This value is fetched from the server and cannot be edited.'.

				(aBuilder setting: #modelSystemPrompt)
					order: 0.6;
					label: 'Model system prompt (read only)';
					target: self;
					getSelector: #modelSystemPrompt;
					setSelector: #modelSystemPrompt:;
					default: self modelSystemPrompt;
					description: 'System prompt defined by the selected Ollama model, when available.'.


				(aBuilder setting: #modelParameters)
					order: 0.7;
					label: 'Model parameters (read only)';
					target: self;
					getSelector: #modelParameters;
					setSelector: #modelParameters:;
					default: self modelParameters;
					description: 'Model parameters provided by the Ollama model definition.'.


				(aBuilder setting: #host)
					order: 1;
					label: 'Server host';
					target: self;
					getSelector: #host;
					setSelector: #host:;
					default: self host.

				(aBuilder setting: #port)
					order: 2;
					label: 'Server port';
					target: self;
					getSelector: #port;
					setSelector: #port:;
					default: self port.

				(aBuilder pickOne: #fimTemplateOption)
					label: 'FIM template source';
					target: self;
					getSelector: #fimTemplateOption;
					setSelector: #fimTemplateOption:;
					default: self fimTemplateOption;
					domainValues: self availableFimTemplateOptions.

				(aBuilder setting: #fimTemplate)
					label: 'FIM template';
					target: self;
					getSelector: #fimTemplate;
					setSelector: #fimTemplate:;
					default: self fimTemplate;
					description: 'Inline template used when the source is set to "Inline (edit below)".'.

				(aBuilder setting: #customFimTemplateFilePath)
					label: 'Custom FIM template file';
					target: self;
					getSelector: #customFimTemplateFilePath;
					setSelector: #customFimTemplateFilePath:;
					default: self customFimTemplateFilePath;
					description: 'Used when the source is set to "Custom template file". The file is created automatically if it does not exist.' ]
]

{ #category : 'accessing' }
CopilotSettings class >> shouldShowDetailedSettings [
    "Show detailed settings if copilot is enabled"
    
    ^ self copilotEnabled

]

{ #category : 'accessing' }
CopilotSettings class >> templatesDirectory [
    ^ (FileLocator imageDirectory / 'pharo-copilot' / 'templates') asFileReference
]
