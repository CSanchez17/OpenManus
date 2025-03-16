"""
This module serves as the entry point for running the Manus agent.
It handles user input and manages the asynchronous execution of the agent.
"""

import asyncio

from app.agent.manus import Manus
from app.logger import logger


async def main():
    """
    The main asynchronous function that initializes the Manus agent,
    prompts the user for input, and processes the request.

    It handles empty input and keyboard interruptions gracefully.

    :return: None
    """
    agent = Manus()
    try:
        prompt = input("Enter your prompt: ")
        if not prompt.strip():
            logger.warning("Empty prompt provided.")
            return

        logger.warning("Processing your request...")
        await agent.run(prompt)
        logger.info("Request processing completed.")
    except KeyboardInterrupt:
        logger.warning("Operation interrupted.")


if __name__ == "__main__":
    asyncio.run(main())
