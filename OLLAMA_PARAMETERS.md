# Ollama Parameters Configuration

Pharo Copilot now supports configurable Ollama parameters with persistent storage. You can configure standard parameters through the Settings UI and add custom parameters via the configuration file.

## Standard Parameters (Available in Settings UI)

The following parameters can be configured through the Pharo Settings UI (Settings > Code Browsing > Copilot > Ollama Parameters):

### Temperature
- **Range:** 0.0 to 2.0
- **Default:** 0.8
- **Description:** Controls randomness in generation. Lower values (closer to 0.0) make output more deterministic and focused, while higher values (closer to 2.0) make output more creative and random.

### Top P (Nucleus Sampling)
- **Range:** 0.0 to 1.0
- **Default:** 0.9
- **Description:** Limits token selection to the smallest set of tokens whose cumulative probability exceeds this threshold. Lower values make output more focused.

### Top K
- **Range:** 1 to 100
- **Default:** 40
- **Description:** Limits token selection to the top K most likely tokens. Lower values make output more focused.

### Max Tokens to Generate (num_predict)
- **Range:** 1 to 2048
- **Default:** 128
- **Description:** Maximum number of tokens to generate in a single completion.

### Repeat Penalty
- **Range:** 0.0 to 2.0
- **Default:** 1.1
- **Description:** Penalizes repetition in generated text. Higher values reduce repetition.

### Context Window Size (num_ctx)
- **Range:** 512 to 32768
- **Default:** nil (uses model default)
- **Description:** Size of the context window. Leave empty to use the model's default.

### Seed
- **Range:** Any integer
- **Default:** nil (random)
- **Description:** Random seed for reproducible generation. Set to a specific number for consistent results, or leave empty for random generation.

## Persistent Storage

All settings (including Ollama parameters) are automatically saved to a configuration file:

**Location:** `<pharo-image-directory>/pharo-copilot/settings.ston`

Settings are automatically saved whenever you change them through the UI or programmatically.

## Custom Parameters (Advanced)

You can add custom Ollama parameters that are not available in the UI by directly editing the settings file or programmatically.

### Method 1: Edit the Configuration File

1. Locate the settings file: `<pharo-image-directory>/pharo-copilot/settings.ston`
2. Open it in a text editor
3. Add custom parameters to the `customParameters` dictionary

Example `settings.ston`:
```smalltalk
{
	#enabled : true,
	#provider : #ollama,
	#modelName : 'pharo-coder-1.5b-fim-f16:latest',
	#host : '127.0.0.1',
	#port : 11434,
	#temperature : 0.8,
	#topP : 0.9,
	#topK : 40,
	#customParameters : {
		#mirostat : 0,
		#mirostat_tau : 5.0,
		#mirostat_eta : 0.1,
		#tfs_z : 1.0,
		#typical_p : 1.0
	}
}
```

### Method 2: Programmatic Configuration

You can set custom parameters programmatically in Pharo:

```smalltalk
"Set a single custom parameter"
CopilotSettings setCustomParameter: #mirostat value: 2.

"Set multiple custom parameters"
CopilotSettings customParameters: (Dictionary new
	at: #mirostat put: 2;
	at: #mirostat_tau put: 5.0;
	at: #mirostat_eta put: 0.1;
	yourself).

"Get a custom parameter"
mirostatValue := CopilotSettings getCustomParameter: #mirostat.

"Get all Ollama options (standard + custom)"
allOptions := CopilotSettings allOllamaOptions.
```

### Supported Ollama Parameters

Ollama supports many additional parameters. Here are some commonly used ones you can add as custom parameters:

- **mirostat** (0, 1, or 2): Enable Mirostat sampling for controlling perplexity
- **mirostat_tau** (float): Target perplexity for Mirostat
- **mirostat_eta** (float): Learning rate for Mirostat
- **tfs_z** (float, default: 1.0): Tail free sampling parameter
- **typical_p** (float, default: 1.0): Locally typical sampling parameter
- **presence_penalty** (float): Presence penalty for token generation
- **frequency_penalty** (float): Frequency penalty for token generation
- **stop** (array of strings): Stop sequences

For a complete list of supported parameters, refer to the [Ollama API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md#generate-a-completion).

## Loading Settings on Startup

Settings are automatically loaded when the image starts. If no settings file exists, default values will be used.

To manually reload settings from file:
```smalltalk
CopilotSettings loadSettingsFromFile.
```

To manually save settings to file:
```smalltalk
CopilotSettings saveSettingsToFile.
```

## Resetting to Defaults

To reset all settings to their default values:
```smalltalk
CopilotSettings resetToDefaultSettings.
```

Note: This will clear in-memory settings but won't delete the settings file. The file will be overwritten with new values when settings are next saved.

## How Parameters Are Applied

1. When `OllamaClient` is initialized, it loads all Ollama parameters from `CopilotSettings`
2. Standard parameters (temperature, top_p, etc.) and custom parameters are merged together
3. These parameters are sent to Ollama in the `options` field of each API request
4. Parameters can be temporarily overridden for specific requests (e.g., the `task` parameter for fill-in-the-middle)

## Example Use Cases

### More Deterministic Completions
```smalltalk
CopilotSettings temperature: 0.2.
CopilotSettings topP: 0.8.
CopilotSettings topK: 20.
```

### More Creative Completions
```smalltalk
CopilotSettings temperature: 1.2.
CopilotSettings topP: 0.95.
CopilotSettings topK: 60.
```

### Reproducible Completions
```smalltalk
CopilotSettings seed: 42.
CopilotSettings temperature: 0.5.
```

### Using Mirostat Sampling
```smalltalk
CopilotSettings setCustomParameter: #mirostat value: 2.
CopilotSettings setCustomParameter: #mirostat_tau value: 5.0.
CopilotSettings setCustomParameter: #mirostat_eta value: 0.1.
```

## Troubleshooting

### Settings Not Persisting
- Check that the `pharo-copilot` directory exists and is writable
- Verify that settings are being saved: check for `settings.ston` file
- Check the logger output for save/load errors

### Custom Parameters Not Working
- Verify parameter names match Ollama's API (use underscores, not camelCase)
- Check Ollama logs to see if parameters are being accepted
- Some parameters may only work with specific models

### Invalid Parameter Values
- Parameters are validated when set through setters
- If editing the file directly, invalid values may be silently ignored
- Check the logger for validation errors

## References

- [Ollama API Documentation](https://github.com/ollama/ollama/blob/main/docs/api.md)
- [Ollama Model Parameters](https://github.com/ollama/ollama/blob/main/docs/modelfile.md#parameter)
