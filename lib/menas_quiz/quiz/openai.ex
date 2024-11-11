defmodule MenasQuiz.Quiz.OpenAI do
  # @api_key System.get_env("OPENAI_API_KEY")
  # @api_url "https://api.openai.com/v1/chat/completions"

  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOpenAI
  alias LangChain.Message

  def fetch_quiz_question(
        previous \\ "",
        difficulty \\ "medium",
        language \\ "German",
        age \\ "9"
      ) do
    {:ok, _updated_chain, response} =
      %{llm: ChatOpenAI.new!(%{model: "gpt-4o-mini"})}
      |> LLMChain.new!()
      |> LLMChain.add_messages([
        Message.new_system!(
          "You are a playful quiz master for young children. Your task is to provide quiz questions that are fun and age-appropriate, with three answer options. Each answer should include an emoji that visually represents it, helping non-readers make a guess. The app will read the question and answers aloud, so each emoji should be clear and contextually related to the answer.

          You must format your response strictly as a JSON object with ONE array for the key `questions` with the following structure:
          - Each entry must include:
            - \"question\" (string): The quiz question.
            - \"solutionId\" (string): The ID of the correct answer.
            - \"answers\" (array of objects), where each object has:
              - \"id\" (string): A unique identifier for the answer.
              - \"text\" (string): The answer text (without emojis).
              - \"emoji\" (string): An emoji representing the answer.

          Important: Do NOT use any other keys or include extra information."
        ),
        Message.new_user!(previous),
        Message.new_user!(
          "Create 5 #{difficulty} level quiz questions suitable for a #{age}-year-old child. Each question should have three unique answers with fitting emojis. Make sure the questions are fresh and have not been used before.

          Respond only with a JSON array like the examples below. Write the response in #{language}:

          Example response:

          {
            \"questions\": [
              {
                \"question\": \"Welches Tier ist am schwersten?\",
                \"solutionId\": \"3\",
                \"answers\": [
                  { \"id\": \"1\", \"text\": \"Schildkröte\", \"emoji\": \"🐢\" },
                  { \"id\": \"2\", \"text\": \"Hase\", \"emoji\": \"🐇\" },
                  { \"id\": \"3\", \"text\": \"Elefant\", \"emoji\": \"🐘\" }
                ]
              },
              {
                \"question\": \"Was ergibt 2+2?\",
                \"solutionId\": \"3\",
                \"answers\": [
                  { \"id\": \"1\", \"text\": \"Zwei\", \"emoji\": \"2️⃣\" },
                  { \"id\": \"2\", \"text\": \"Drei\", \"emoji\": \"3️⃣\" },
                  { \"id\": \"3\", \"text\": \"Vier\", \"emoji\": \"4️⃣\" }
                ]
              }
            ]
          }

          Do not add any explanations or deviate from this format."
        )
      ])
      |> LLMChain.run()

    {:ok, response}
  end
end
