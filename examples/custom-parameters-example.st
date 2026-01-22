"Example: Configuring Ollama Parameters in Pharo Copilot"

"======================"
"STANDARD PARAMETERS"
"======================"

"Configure standard parameters through the API"
CopilotSettings temperature: 0.8.
CopilotSettings topP: 0.9.
CopilotSettings topK: 40.
CopilotSettings numPredict: 256.
CopilotSettings repeatPenalty: 1.1.

"Optional: Set context window size (or leave as nil for model default)"
CopilotSettings numCtx: 4096.

"Optional: Set seed for reproducible generation"
CopilotSettings seed: 42.


"======================"
"CUSTOM PARAMETERS"
"======================"

"Add a single custom parameter"
CopilotSettings setCustomParameter: #mirostat value: 2.

"Add multiple custom parameters at once"
CopilotSettings customParameters: (Dictionary new
	at: #mirostat put: 2;
	at: #mirostat_tau put: 5.0;
	at: #mirostat_eta put: 0.1;
	at: #tfs_z put: 1.0;
	yourself).

"Get a specific custom parameter"
mirostatValue := CopilotSettings getCustomParameter: #mirostat.


"======================"
"VIEWING ALL PARAMETERS"
"======================"

"Get all Ollama options (standard + custom) that will be sent to the API"
allOptions := CopilotSettings allOllamaOptions.
allOptions inspect.


"======================"
"PERSISTENCE"
"======================"

"Settings are automatically saved when changed, but you can also manually save"
CopilotSettings saveSettingsToFile.

"Load settings from file (automatically done on startup)"
CopilotSettings loadSettingsFromFile.

"View the settings file location"
settingsFile := CopilotSettings settingsFileReference.
settingsFile inspect.


"======================"
"PRESET CONFIGURATIONS"
"======================"

"Example 1: More Deterministic Completions"
CopilotSettings temperature: 0.2.
CopilotSettings topP: 0.8.
CopilotSettings topK: 20.
CopilotSettings seed: 12345.

"Example 2: More Creative Completions"
CopilotSettings temperature: 1.2.
CopilotSettings topP: 0.95.
CopilotSettings topK: 60.
CopilotSettings seed: nil. "Random seed"

"Example 3: Balanced (Default) Settings"
CopilotSettings temperature: 0.8.
CopilotSettings topP: 0.9.
CopilotSettings topK: 40.
CopilotSettings numPredict: 128.
CopilotSettings repeatPenalty: 1.1.

"Example 4: Using Mirostat Sampling"
CopilotSettings temperature: 0.8.
CopilotSettings setCustomParameter: #mirostat value: 2.
CopilotSettings setCustomParameter: #mirostat_tau value: 5.0.
CopilotSettings setCustomParameter: #mirostat_eta value: 0.1.


"======================"
"RESETTING TO DEFAULTS"
"======================"

"Reset all settings to defaults (in-memory only)"
CopilotSettings resetToDefaultSettings.


"======================"
"DIRECT FILE EDITING"
"======================"

"You can also edit the settings file directly at:"
"<pharo-image-directory>/pharo-copilot/settings.ston"

"Example settings.ston content:"
"
{
	#enabled : true,
	#provider : #ollama,
	#modelName : 'pharo-coder-1.5b-fim-f16:latest',
	#host : '127.0.0.1',
	#port : 11434,
	#temperature : 0.8,
	#topP : 0.9,
	#topK : 40,
	#numPredict : 128,
	#repeatPenalty : 1.1,
	#numCtx : nil,
	#seed : nil,
	#customParameters : {
		#mirostat : 2,
		#mirostat_tau : 5.0,
		#mirostat_eta : 0.1
	}
}
"
