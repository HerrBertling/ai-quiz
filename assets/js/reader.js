export function readText(text) {
  // Split the text into an array of parts: question and answers
  const textBits = text.split("\n").filter(entry => entry.trim() !== '');

  if ('speechSynthesis' in window) {
    const synth = window.speechSynthesis;
    const utteranceQueue = [];

    // Iterate over each part (question and answers) and create an utterance for each
    textBits.forEach((bit, index) => {
      if (index === 0) {
        // This is the question part
        const questionUtterance = new SpeechSynthesisUtterance(bit);
        questionUtterance.lang = "de-DE";
        questionUtterance.rate = 0.6;
        utteranceQueue.push(questionUtterance);
      } else {
        // This is an answer part
        const prefix = String.fromCharCode(64 + index) + "."; // A., B., C., etc.

        // Create a separate utterance for the prefix letter
        const prefixUtterance = new SpeechSynthesisUtterance(prefix);
        prefixUtterance.lang = "de-DE";
        prefixUtterance.rate = 0.2;
        utteranceQueue.push(prefixUtterance);

        // Add a short silent utterance to create a pause between the letter and the answer
        const pauseUtterance = new SpeechSynthesisUtterance(' ');
        pauseUtterance.lang = "de-DE";
        pauseUtterance.rate = 0.2;
        pauseUtterance.volume = 0; // Silent utterance
        utteranceQueue.push(pauseUtterance);

        // Create the answer utterance
        const answerUtterance = new SpeechSynthesisUtterance(bit);
        answerUtterance.lang = "de-DE";
        answerUtterance.rate = 0.6;
        utteranceQueue.push(answerUtterance);
      }

      // Add a pause after each part except the last one
      if (index < textBits.length - 1) {
        const pauseUtterance = new SpeechSynthesisUtterance(' ');
        pauseUtterance.lang = "de-DE";
        pauseUtterance.rate = 0.1;
        pauseUtterance.volume = 0; // Silent utterance for pause
        utteranceQueue.push(pauseUtterance);
      }
    });

    // Speak each utterance in sequence
    utteranceQueue.forEach(utterance => {
      synth.speak(utterance);
    });
  } else {
    console.log('Web Speech API is not supported in this browser.');
  }
}
