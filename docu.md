# OpenManus Project

## Purpose
The OpenManus project is designed to provide an all-capable AI assistant that can solve a wide range of tasks presented by users. It leverages various tools to efficiently complete complex requests, including programming, information retrieval, file processing, and web browsing.

## Key Features
- **Python Execution**: Execute Python code for system interaction, data processing, and automation tasks.
- **File Saving**: Save content to local files, supporting various formats like txt, py, and html.
- **Web Browsing**: Open and interact with web browsers for navigation, content extraction, and more.
- **Web Search**: Perform web searches to retrieve up-to-date information.
- **Task Termination**: End interactions when tasks are completed or require further user input.

This project is ideal for developers looking to integrate a versatile AI assistant into their applications, providing robust support for a variety of tasks.

# Developer Documentation for OpenManus

## Overview
This document provides an overview of the files and directories in the OpenManus project, describing their purpose and functionality.

## Directory Structure

### app/
- **schema.py**: Defines data models and schemas used throughout the application.
- **logger.py**: Configures and provides logging functionality for the application.
- **llm.py**: Contains logic related to language model interactions and processing.
- **config.py**: Manages configuration settings and parameters for the application.
- **exceptions.py**: Defines custom exceptions used in the application.
- **__init__.py**: Marks the directory as a Python package.

### app/agent/
- **swe.py**: Contains logic for the SWE (Software Engineering) agent.
- **toolcall.py**: Manages tool calling mechanisms for the agent.
- **manus.py**: Implements the core Manus agent functionality.
- **planning.py**: Handles planning tasks for the agent.
- **react.py**: Manages reactive behaviors of the agent.
- **base.py**: Provides base classes and utilities for agents.
- **__init__.py**: Marks the directory as a Python package.

### app/flow/
- **planning.py**: Implements planning flows for task execution.
- **base.py**: Contains base classes for flow management.
- **flow_factory.py**: Factory for creating flow instances.
- **__init__.py**: Marks the directory as a Python package.

### app/prompt/
- **planning.py**: Manages planning-related prompts.
- **swe.py**: Handles prompts for the SWE agent.
- **toolcall.py**: Manages tool call prompts.
- **manus.py**: Handles prompts for the Manus agent.
- **__init__.py**: Marks the directory as a Python package.

### app/tool/
- **terminate.py**: Provides functionality to terminate tasks.
- **tool_collection.py**: Manages a collection of tools.
- **web_search.py**: Implements web search capabilities.
- **str_replace_editor.py**: Handles string replacement and editing.
- **terminal.py**: Manages terminal interactions.
- **python_execute.py**: Executes Python code.
- **run.py**: Manages execution of run tasks.
- **create_chat_completion.py**: Handles chat completion tasks.
- **file_saver.py**: Provides file saving capabilities.
- **planning.py**: Implements planning tools.
- **bash.py**: Manages bash command execution.
- **browser_use_tool.py**: Provides browser interaction tools.
- **base.py**: Contains base classes for tools.
- **__init__.py**: Marks the directory as a Python package.

## Main Files

### main.py
- Entry point for running the Manus agent. Handles user input and manages asynchronous execution.

### run_flow.py
- Executes a flow using the Manus agent based on user input. Handles timeouts and interruptions.

### setup.py
- Used for packaging and distributing the OpenManus project. Defines metadata and dependencies.

## Additional Information
- **CHANGELOG.md**: Records all notable changes to the project.
- **README.md**: Provides an overview, installation instructions, and usage examples.

## Contributing
- Please refer to the `CONTRIBUTING.md` file for guidelines on contributing to the project.

## License
- The project is licensed under the MIT License. See the `LICENSE` file for more details.

### app/schema.py
- **Role**: Enum class defining message role options (`SYSTEM`, `USER`, `ASSISTANT`, `TOOL`).
- **ToolChoice**: Enum class for tool choice options (`NONE`, `AUTO`, `REQUIRED`).
- **AgentState**: Enum class for agent execution states (`IDLE`, `RUNNING`, `FINISHED`, `ERROR`).
- **Function**: Pydantic model representing a function with `name` and `arguments`.
- **ToolCall**: Pydantic model representing a tool/function call in a message with attributes `id`, `type`, and `function`.
- **Message**: Pydantic model representing a chat message with attributes `role`, `content`, `tool_calls`, `name`, and `tool_call_id`.
  - Methods:
    - `__add__`: Combines messages into a list.
    - `__radd__`: Supports reverse addition of messages.
    - `to_dict`: Converts the message to a dictionary.
    - `user_message`: Creates a user message.
    - `system_message`: Creates a system message.
    - `assistant_message`: Creates an assistant message.
    - `tool_message`: Creates a tool message.
    - `from_tool_calls`: Creates messages from tool calls.
- **Memory**: Pydantic model for managing message memory with attributes `messages` and `max_messages`.
  - Methods:
    - `add_message`: Adds a single message to memory.
    - `add_messages`: Adds multiple messages to memory.
    - `clear`: Clears all messages from memory.
    - `get_recent_messages`: Retrieves the most recent messages.
    - `to_dict_list`: Converts messages to a list of dictionaries.

### app/logger.py
- **define_log_level**: Configures the logging levels and log file naming.
  - Parameters:
    - `print_level` (str): The logging level for console output (default: "INFO").
    - `logfile_level` (str): The logging level for file output (default: "DEBUG").
    - `name` (str, optional): A prefix for the log file name.
  - Returns:
    - `logger`: Configured logger instance.
- **logger**: An instance of the configured logger used throughout the application.

### app/llm.py
- **LLM**: Class for managing language model interactions.
  - Attributes:
    - `_instances`: Dictionary to manage LLM instances.
  - Methods:
    - `__new__`: Creates a new instance of LLM or returns an existing one.
      - Parameters:
        - `config_name` (str): Configuration name (default: "default").
        - `llm_config` (Optional[LLMSettings]): LLM configuration settings.
    - `__init__`: Initializes the LLM instance with configuration settings.
    - `count_tokens`: Calculates the number of tokens in a given text.
      - Parameters:
        - `text` (str): The text to count tokens in.
      - Returns:
        - `int`: Number of tokens.
    - `count_message_tokens`: Calculates the number of tokens in a list of messages.
      - Parameters:
        - `messages` (List[dict]): List of messages.
      - Returns:
        - `int`: Number of tokens.
    - `update_token_count`: Updates the token count.
      - Parameters:
        - `input_tokens` (int): Number of input tokens.
    - `check_token_limit`: Checks if the token limit is exceeded.
      - Parameters:
        - `input_tokens` (int): Number of input tokens.
      - Returns:
        - `bool`: True if limit is not exceeded, False otherwise.
    - `get_limit_error_message`: Gets the error message for token limit exceedance.
      - Parameters:
        - `input_tokens` (int): Number of input tokens.
      - Returns:
        - `str`: Error message.
    - `format_messages`: Formats a list of messages for LLM.
      - Parameters:
        - `messages` (List[Union[dict, Message]]): List of messages.
      - Returns:
        - `List[dict]`: Formatted messages.
    - `ask`: Asynchronously sends a request to the language model.
      - Parameters:
        - `messages` (List[Union[dict, Message]]): List of messages.
        - `system_msgs` (Optional[List[Union[dict, Message]]]): System messages.
        - `stream` (bool): Whether to stream the response.
        - `temperature` (Optional[float]): Temperature setting for randomness.
      - Returns:
        - `str`: Response from the language model.
    - `ask_tool`: Asynchronously sends a request with tool options.
      - Parameters:
        - `messages` (List[Union[dict, Message]]): List of messages.
        - `system_msgs` (Optional[List[Union[dict, Message]]]): System messages.
        - `timeout` (int): Timeout for the request.
        - `tools` (Optional[List[dict]]): List of tools.
        - `tool_choice` (TOOL_CHOICE_TYPE): Tool choice option.
        - `temperature` (Optional[float]): Temperature setting for randomness.
      - Returns:
        - `ChatCompletionMessage`: The model's response.

### app/config.py
- **get_project_root**: Function to get the project root directory.
  - Returns:
    - `Path`: Path to the project root.
- **LLMSettings**: Pydantic model for language model settings.
  - Attributes:
    - `model` (str): Model name.
    - `base_url` (str): API base URL.
    - `api_key` (str): API key.
    - `max_tokens` (int): Maximum number of tokens per request.
    - `max_input_tokens` (Optional[int]): Maximum input tokens (None for unlimited).
    - `temperature` (float): Sampling temperature.
    - `api_type` (str): API type (AzureOpenai or Openai).
    - `api_version` (str): API version for Azure Openai.
- **ProxySettings**: Pydantic model for proxy settings.
  - Attributes:
    - `server` (str): Proxy server address.
    - `username` (Optional[str]): Proxy username.
    - `password` (Optional[str]): Proxy password.
- **SearchSettings**: Pydantic model for search settings.
  - Attributes:
    - `engine` (str): Search engine to use.
- **BrowserSettings**: Pydantic model for browser settings.
  - Attributes:
    - `headless` (bool): Run browser in headless mode.
    - `disable_security` (bool): Disable browser security features.
    - `extra_chromium_args` (List[str]): Extra arguments for the browser.
    - `chrome_instance_path` (Optional[str]): Path to a Chrome instance.
    - `wss_url` (Optional[str]): WebSocket URL for browser connection.
    - `cdp_url` (Optional[str]): CDP URL for browser connection.
    - `proxy` (Optional[ProxySettings]): Proxy settings.
- **AppConfig**: Pydantic model for application configuration.
  - Attributes:
    - `llm` (Dict[str, LLMSettings]): Language model settings.
    - `browser_config` (Optional[BrowserSettings]): Browser configuration.
    - `search_config` (Optional[SearchSettings]): Search configuration.
- **Config**: Singleton class for managing application configuration.
  - Methods:
    - `__new__`: Creates a new instance of Config or returns an existing one.
    - `__init__`: Initializes the Config instance, loading initial configuration if not already initialized.
    - `_get_config_path`: Retrieves the path to the configuration file.
      - Returns:
        - `Path`: Path to the configuration file.
    - `_load_config`: Loads the configuration from a file.
      - Returns:
        - `dict`: Loaded configuration data.
    - `_load_initial_config`: Loads the initial configuration, setting up LLM, browser, and search settings.
    - `llm`: Property to access language model settings.
      - Returns:
        - `Dict[str, LLMSettings]`: Language model settings.
    - `browser_config`: Property to access browser configuration.
      - Returns:
        - `Optional[BrowserSettings]`: Browser configuration.
    - `search_config`: Property to access search configuration.
      - Returns:
        - `Optional[SearchSettings]`: Search configuration.

### app/exceptions.py
- **ToolError**: Exception raised when a tool encounters an error.
  - Attributes:
    - `message` (str): Error message describing the issue encountered by the tool.
- **OpenManusError**: Base exception for all OpenManus errors, serving as a parent class for specific exceptions.
- **TokenLimitExceeded**: Exception raised when the token limit is exceeded, inheriting from `OpenManusError`.

### app/agent/swe.py
- **SWEAgent**: An agent that implements the SWEAgent paradigm for executing code and natural conversations.
  - Attributes:
    - `name` (str): Name of the agent, set to "swe".
    - `description` (str): Description of the agent's purpose, which is to interact directly with the computer to solve tasks.
    - `system_prompt` (str): System prompt for the agent, initialized with `SYSTEM_PROMPT`.
    - `next_step_prompt` (str): Template for the next step prompt, initialized with `NEXT_STEP_TEMPLATE`.
    - `available_tools` (ToolCollection): Collection of tools available to the agent, including `Bash`, `StrReplaceEditor`, and `Terminate`.
    - `special_tool_names` (List[str]): Names of special tools, initialized with the name of the `Terminate` tool.
    - `max_steps` (int): Maximum number of steps the agent can take, set to 30.
    - `bash` (Bash): Bash tool for executing shell commands, initialized with a default factory.
    - `working_dir` (str): Current working directory, initialized to ".".
  - Methods:
    - `think`: Asynchronously processes the current state and decides the next action.
      - Returns: `bool` indicating whether the agent should continue.

### app/agent/toolcall.py
- **ToolCallAgent**: The ToolCallAgent class in app/agent/toolcall.py includes several methods that handle tool calls and manage the agent's decision-making process..
  - Attributes:
    - `name` (str): Name of the agent, set to "toolcall".
    - `description` (str): Description of the agent's purpose, which is to execute tool calls.
    - `system_prompt` (str): System prompt for the agent, initialized with `SYSTEM_PROMPT`.
    - `next_step_prompt` (str): Template for the next step prompt, initialized with `NEXT_STEP_PROMPT`.
    - `available_tools` (ToolCollection): Collection of tools available to the agent, including `CreateChatCompletion` and `Terminate`.
    - `tool_choices` (TOOL_CHOICE_TYPE): Tool choice option, set to `ToolChoice.AUTO`.
    - `special_tool_names` (List[str]): Names of special tools, initialized with the name of the `Terminate` tool.
    - `tool_calls` (List[ToolCall]): List of tool calls made by the agent.
    - `max_steps` (int): Maximum number of steps the agent can take, set to 30.
    - `max_observe` (Optional[Union[int, bool]]): Maximum observation steps, initially set to `None`.
  - Methods:
    - `execute_tool`: Asynchronously executes a single tool call with robust error handling.
      - Parameters:
        - `command` (ToolCall): The tool call to execute.
      - Returns: `str` containing the result or error message.
      - Details:
        - Validates the command format and tool availability.
        - Parses arguments and executes the tool.
        - Handles special tools and formats the result for display.
        - Logs errors related to JSON parsing and tool execution.

    - `_handle_special_tool`: Handles special tool execution and state changes.
      - Parameters:
        - `name` (str): Name of the tool.
        - `result` (Any): Result of the tool execution.
      - Details:
        - Checks if the tool is special and updates the agent's state if necessary.

    - `_should_finish_execution`: Determines if tool execution should finish the agent.
      - Returns: `bool` indicating if execution should finish.

    - `_is_special_tool`: Checks if a tool name is in the special tools list.
      - Parameters:
        - `name` (str): Name of the tool.
      - Returns: `bool` indicating if the tool is special.

    - `think`: Asynchronously processes the current state and decides the next actions using tools.
      - Returns: `bool` indicating whether the agent should continue.
      - Details:
        - Handles token limit errors and logs relevant information.
        - Manages tool call responses and updates the agent's memory.
        - Handles different tool choice modes (`NONE`, `REQUIRED`, `AUTO`).

    - `act`: Asynchronously executes tool calls and handles their results.
      - Returns: `str` containing the result of the action.
      - Details:
        - Raises a `ValueError` if tool calls are required but none are provided.
        - Executes each tool call and logs the results.
        - Truncates results if `max_observe` is set.

### app/agent/manus.py
- **Manus**: The Manus class in app/agent/manus.py is a versatile general-purpose agent that extends the ToolCallAgent class.
  - Attributes:
    - `name` (str): Name of the agent, set to "Manus".
    - `description` (str): Description of the agent's purpose, which is to solve various tasks using multiple tools.
    - `system_prompt` (str): System prompt for the agent, initialized with `SYSTEM_PROMPT`.
    - `next_step_prompt` (str): Template for the next step prompt, initialized with `NEXT_STEP_PROMPT`.
    - `max_observe` (int): Maximum observation steps, set to 2000.
    - `max_steps` (int): Maximum number of steps the agent can take, set to 20.
    - `available_tools` (ToolCollection): Collection of tools available to the agent, including `PythonExecute`, `WebSearch`, `BrowserUseTool`, `FileSaver`, and `Terminate`.
  - Methods:
    - `_handle_special_tool`: Asynchronously handles special tool execution.
      - Parameters:
        - `name` (str): Name of the tool.
        - `result` (Any): Result of the tool execution.
      - Details:
        - Checks if the tool is special and performs cleanup for `BrowserUseTool` before calling the superclass method.

### app/agent/planning.py
- **PlanningAgent**: An agent that creates and manages plans to solve tasks.
  - Attributes:
    - `name` (str): Name of the agent, set to "planning".
    - `description` (str): Description of the agent's purpose, which is to create and manage plans to solve tasks.
    - `system_prompt` (str): System prompt for the agent, initialized with `PLANNING_SYSTEM_PROMPT`.
    - `next_step_prompt` (str): Template for the next step prompt, initialized with `NEXT_STEP_PROMPT`.
    - `available_tools` (ToolCollection): Collection of tools available to the agent, including `PlanningTool` and `Terminate`.
    - `tool_choices` (TOOL_CHOICE_TYPE): Tool choice option, set to `ToolChoice.AUTO`.
    - `special_tool_names` (List[str]): Names of special tools, initialized with the name of the `Terminate` tool.
    - `tool_calls` (List[ToolCall]): List of tool calls made by the agent.
    - `active_plan_id` (Optional[str]): ID of the active plan, initially set to `None`.
    - `step_execution_tracker` (Dict[str, Dict]): Tracker for step execution status.
    - `current_step_index` (Optional[int]): Index of the current step, initially set to `None`.
    - `max_steps` (int): Maximum number of steps the agent can take, set to 20.
  - Methods:
    - `initialize_plan_and_verify_tools`: Initializes the agent with a default plan ID and validates required tools.
      - Returns: `PlanningAgent` instance.
    - `think`: Asynchronously decides the next action based on the current plan status.
      - Returns: `bool` indicating whether the agent should continue.
    - `act`: Asynchronously executes a step and tracks its completion status.
      - Returns: `str` containing the result of the action.
    - `get_plan`: Retrieves the current plan status.
      - Returns: `str` containing the current plan status.
    - `run`: Asynchronously runs the agent with an optional request.
      - Parameters:
        - `request` (Optional[str]): The request to process.
      - Returns: `str` containing the result of the run.
    - `update_plan_status`: Updates the current plan progress based on completed tool execution.
      - Parameters:
        - `tool_call_id` (str): ID of the tool call to update.
    - `_get_current_step_index`: Parses the current plan to identify the first non-completed step's index.
      - Returns: `Optional[int]` indicating the current step index.
    - `create_initial_plan`: Creates an initial plan based on the request.
      - Parameters:
        - `request` (str): The request to create a plan for.

### app/agent/react.py
- **ReActAgent**: An agent that uses the ReAct framework to solve tasks by reasoning and acting.
  - Attributes:
    - `name` (str): Name of the agent.
    - `description` (Optional[str]): Description of the agent's purpose.
    - `system_prompt` (Optional[str]): System prompt for the agent.
    - `next_step_prompt` (Optional[str]): Template for the next step prompt.
    - `llm` (Optional[LLM]): Language model instance used by the agent.
    - `memory` (Memory): Memory for managing messages and state.
    - `state` (AgentState): Current state of the agent.
    - `max_steps` (int): Maximum number of steps the agent can take.
    - `current_step` (int): Current step number.
  - Methods:
    - `think`: Abstract method for processing the current state and deciding the next action.
      - Returns:
        - `bool`: True if the agent should continue, False otherwise.
    - `act`: Abstract method for performing an action based on the current state.
      - Returns:
        - `str`: Result of the action.
    - `step`: Asynchronously performs a single step of reasoning and acting.
      - Returns:
        - `str`: Result of the step.

### app/agent/base.py
- **BaseAgent**: Abstract base class for managing agent state and execution.
  - Attributes:
    - `name` (str): Unique name of the agent.
    - `description` (Optional[str]): Optional agent description.
    - `system_prompt` (Optional[str]): System-level instruction prompt.
    - `next_step_prompt` (Optional[str]): Prompt for determining next action.
    - `llm` (LLM): Language model instance.
    - `memory` (Memory): Agent's memory store.
    - `state` (AgentState): Current agent state.
    - `max_steps` (int): Maximum steps before termination.
    - `current_step` (int): Current step in execution.
    - `duplicate_threshold` (int): Threshold for duplicate detection.
  - Methods:
    - `initialize_agent`: Initializes the agent after validation.
      - Returns:
        - `BaseAgent`: The initialized agent.
    - `state_context`: Asynchronously manages state transitions.
      - Parameters:
        - `new_state` (AgentState): The new state to transition to.
    - `update_memory`: Updates the agent's memory with a new message.
      - Parameters:
        - `role` (ROLE_TYPE): Role of the message.
        - `content` (str): Content of the message.
    - `run`: Asynchronously runs the agent with an optional request.
      - Parameters:
        - `request` (Optional[str]): The request to process.
      - Returns:
        - `str`: Result of the run.
    - `step`: Abstract method for performing a single step of execution.
      - Returns:
        - `str`: Result of the step.
    - `handle_stuck_state`: Handles situations where the agent is stuck.
    - `is_stuck`: Checks if the agent is stuck.
      - Returns:
        - `bool`: True if the agent is stuck, False otherwise.
    - `messages`: Property to get or set the agent's messages.
      - Returns:
        - `List[Message]`: List of messages.

### app/flow/planning.py
- **PlanningFlow**: A flow that manages planning and execution of tasks using agents.
  - Attributes:
    - `llm` (LLM): Language model instance used for planning.
    - `planning_tool` (PlanningTool): Tool for creating and managing plans.
    - `executor_keys` (List[str]): Keys for executors involved in the flow.
    - `active_plan_id` (str): Identifier for the active plan.
    - `current_step_index` (Optional[int]): Index of the current step in the plan.
  - Methods:
    - `__init__`: Initializes the PlanningFlow with agents and additional data.
      - Parameters:
        - `agents` (Union[BaseAgent, List[BaseAgent], Dict[str, BaseAgent]]): Agents involved in the flow.
    - `get_executor`: Retrieves the executor for a given step type.
      - Parameters:
        - `step_type` (Optional[str]): Type of step to execute.
      - Returns:
        - `BaseAgent`: The executor agent.
    - `execute`: Asynchronously executes the flow with the given input text.
      - Parameters:
        - `input_text` (str): Text input for execution.
      - Returns:
        - `str`: Result of the execution.
    - `_create_initial_plan`: Asynchronously creates an initial plan based on a request.
      - Parameters:
        - `request` (str): The request to create a plan for.
    - `_get_current_step_info`: Asynchronously retrieves information about the current step.
      - Returns:
        - `tuple[Optional[int], Optional[dict]]`: Current step index and step information.
    - `_execute_step`: Asynchronously executes a step with the given executor and step information.
      - Parameters:
        - `executor` (BaseAgent): The executor agent.
        - `step_info` (dict): Information about the step.
      - Returns:
        - `str`: Result of the step execution.
    - `_mark_step_completed`: Asynchronously marks the current step as completed.
    - `_get_plan_text`: Asynchronously retrieves the text of the current plan.
      - Returns:
        - `str`: Text of the current plan.
    - `_generate_plan_text_from_storage`: Generates plan text from stored data.
      - Returns:
        - `str`: Generated plan text.
    - `_finalize_plan`: Asynchronously finalizes the current plan.
      - Returns:
        - `str`: Finalized plan text.

### app/flow/base.py
- **BaseFlow**: Base class for execution flows supporting multiple agents.
  - Attributes:
    - `agents` (Dict[str, BaseAgent]): Dictionary of agents involved in the flow.
    - `tools` (Optional[List]): List of tools available in the flow.
    - `primary_agent_key` (Optional[str]): Key for the primary agent in the flow.
  - Methods:
    - `__init__`: Initializes the BaseFlow with agents and additional data.
      - Parameters:
        - `agents` (Union[BaseAgent, List[BaseAgent], Dict[str, BaseAgent]]): Agents involved in the flow.
    - `primary_agent`: Property to get the primary agent.
      - Returns:
        - `Optional[BaseAgent]`: The primary agent.
    - `get_agent`: Retrieves an agent by key.
      - Parameters:
        - `key` (str): Key of the agent to retrieve.
      - Returns:
        - `Optional[BaseAgent]`: The agent corresponding to the key.
    - `add_agent`: Adds an agent to the flow.
      - Parameters:
        - `key` (str): Key for the agent.
        - `agent` (BaseAgent): The agent to add.
    - `execute`: Abstract method for executing the flow with the given input text.
      - Parameters:
        - `input_text` (str): Text input for execution.
      - Returns:
        - `str`: Result of the execution.

- **FlowType**: Enum class defining types of flows.
  - Members:
    - `PLANNING`: Represents a planning flow.

- **PlanStepStatus**: Enum class defining possible statuses of a plan step.
  - Members:
    - `NOT_STARTED`: Step has not started.
    - `IN_PROGRESS`: Step is in progress.
    - `COMPLETED`: Step is completed.
    - `BLOCKED`: Step is blocked.
  - Methods:
    - `get_all_statuses`: Retrieves all possible statuses.
      - Returns:
        - `list[str]`: List of all statuses.
    - `get_active_statuses`: Retrieves active statuses.
      - Returns:
        - `list[str]`: List of active statuses.
    - `get_status_marks`: Retrieves status marks.
      - Returns:
        - `Dict[str, str]`: Dictionary of status marks.

### app/flow/flow_factory.py
- **FlowFactory**: Factory for creating different types of flows with support for multiple agents.
  - Methods:
    - `create_flow`: Static method to create a flow based on the specified type.
      - Parameters:
        - `flow_type` (FlowType): Type of flow to create.
        - `agents` (Union[BaseAgent, List[BaseAgent], Dict[str, BaseAgent]]): Agents involved in the flow.
        - `**kwargs`: Additional keyword arguments for flow creation.
      - Returns:
        - `BaseFlow`: The created flow instance.

### app/prompt/planning.py
- **PLANNING_SYSTEM_PROMPT**: A system prompt for the Planning Agent, outlining its responsibilities and available tools.
- **NEXT_STEP_PROMPT**: A prompt asking the agent to determine its next action based on the current state.

### app/prompt/swe.py
- **SYSTEM_PROMPT**: A system prompt for an autonomous programmer working in a command line interface, detailing the response format and command usage.

### app/prompt/toolcall.py
- **SYSTEM_PROMPT**: A system prompt for an agent capable of executing tool calls.
- **NEXT_STEP_PROMPT**: A prompt advising the agent to use the `terminate` tool/function call to stop interaction.

### app/prompt/manus.py
- **SYSTEM_PROMPT**: A system prompt for OpenManus, an all-capable AI assistant, detailing its capabilities and tool usage for solving tasks.
- **NEXT_STEP_PROMPT**: A prompt outlining the tools available to OpenManus, including PythonExecute, FileSaver, BrowserUseTool, WebSearch, and Terminate, with guidance on their usage and interaction strategy.

### app/tool/terminate.py
- **Terminate**: A tool class for terminating interactions when tasks are completed or cannot proceed further.
  - Attributes:
    - `name` (str): Name of the tool.
    - `description` (str): Description of the tool's purpose.
    - `parameters` (dict): Parameters required for execution, including `status` which indicates the finish status of the interaction (`success` or `failure`).
  - Methods:
    - `execute`: Asynchronously finishes the current execution.
      - Parameters:
        - `status` (str): The finish status of the interaction.
      - Returns:
        - `str`: Message indicating the completion status of the interaction.

### app/tool/tool_collection.py
- **ToolCollection**: A class for managing a collection of tools.
  - Methods:
    - `__init__`: Initializes the ToolCollection with a list of tools.
    - `__iter__`: Returns an iterator over the tools.
    - `to_params`: Converts the tools to a list of parameter dictionaries.
      - Returns:
        - `List[Dict[str, Any]]`: List of tool parameters.
    - `execute`: Asynchronously executes a tool by name with given input.
      - Parameters:
        - `name` (str): Name of the tool to execute.
        - `tool_input` (Dict[str, Any], optional): Input parameters for the tool.
      - Returns:
        - `ToolResult`: Result of the tool execution.
    - `execute_all`: Asynchronously executes all tools in the collection sequentially.
      - Returns:
        - `List[ToolResult]`: List of results from each tool execution.
    - `get_tool`: Retrieves a tool by name.
      - Parameters:
        - `name` (str): Name of the tool to retrieve.
      - Returns:
        - `BaseTool`: The tool instance.
    - `add_tool`: Adds a single tool to the collection.
      - Parameters:
        - `tool` (BaseTool): The tool to add.
      - Returns:
        - `ToolCollection`: The updated tool collection.
    - `add_tools`: Adds multiple tools to the collection.
      - Parameters:
        - `*tools` (BaseTool): Tools to add.
      - Returns:
        - `ToolCollection`: The updated tool collection.

### app/tool/web_search.py
- **WebSearch**: The WebSearch class in app/tool/web_search.py is designed to perform web searches and return relevant links..
  - Attributes:
    - `name` (str): Name of the tool, set to "web_search".
    - `description` (str): Description of the tool's purpose, which is to perform a web search and return a list of relevant links.
    - `parameters` (dict): Parameters required for execution, including `query` and `num_results`.
    - `_search_engine` (dict[str, WebSearchEngine]): Dictionary mapping search engine names to their respective instances.
  - Methods:
    - `execute`: Asynchronously performs a web search and returns a list of URLs.
      - Parameters:
        - `query` (str): The search query to submit to the search engine.
        - `num_results` (int, optional): The number of search results to return, defaulting to 10.
      - Returns:
        - `List[str]`: A list of URLs matching the search query.
      - Details: Iterates over search engines in a preferred order, attempting to perform a search with each until successful.
    - `_get_engine_order`: Determines the order in which to try search engines.
      - Returns:
        - `List[str]`: Ordered list of search engine names.
      - Details: Uses the preferred engine from the configuration, followed by the remaining engines.
    - `_perform_search_with_engine`: Asynchronously performs a search using a specified search engine.
      - Parameters:
        - `engine` (WebSearchEngine): The search engine to use.
        - `query` (str): The search query.
        - `num_results` (int): The number of search results to return.
      - Returns:
        - `List[str]`: URLs from the search results.
      - Details: Uses the `tenacity` library to retry the search up to three times with exponential backoff in case of failure.
