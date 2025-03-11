import { Component } from '@angular/core';
import {OpenaiService} from "../openai.service";

@Component({
  selector: 'app-chat',
  templateUrl: './chat.component.html',
  styleUrls: ['./chat.component.css']
})
export class ChatComponent {
  userInput: string = '';
  conversationHistory: { role: string, content: string, isCode: boolean} [] = [];
  isTyping: boolean = false;
  stopTyping: boolean = false;
  isProcessing: boolean = false;

  constructor(private openaiService: OpenaiService) {
  }

  async sendMessage() {
    if (this.userInput.trim() === '') return;

    this.conversationHistory.push({role: 'user', content: this.userInput, isCode: false});

    const messageToSend = this.userInput;
    this.userInput = '';
    try {
      this.isProcessing = true;
      const response = await this.openaiService.getChatResponse(messageToSend);

      this.splitAndAddResponse(response);
      // this.conversationHistory.push({ role: 'assistant', content: '' });

      this.isTyping = true;
      this.stopTyping = false;
      // await this.typeResponse(response);
      this.isTyping = false;

      this.userInput = '';
    } catch (error) {
      this.conversationHistory.push({ role: 'assistant', content: 'Error getting response from AI Server.', isCode: false});
    } finally {
      // Clear user input in the finally block to ensure it's cleared regardless of success or error
      this.userInput = '';
      this.isProcessing = false;
    }
    this.userInput = '';
  }

  handleKeyDown(event: KeyboardEvent) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();  // Prevents newline insertion
      this.sendMessage();
      this.userInput = '';
    }
  }

  async typeResponse(response: string) {
    const typingSpeed = 2; // Adjust typing speed (milliseconds per character)
    let currentText = '';
    for (let i = 0; i < response.length; i++) {
      if (this.stopTyping) break;
      currentText += response[i];
      this.updateLatestBotMessage(currentText);
      await this.delay(typingSpeed);
    }
    this.isTyping = false;
  }

  updateLatestBotMessage(content: string) {
    const latestBotMessageIndex = this.conversationHistory.length - 1;
    if (this.conversationHistory[latestBotMessageIndex].role === 'assistant') {
      this.conversationHistory[latestBotMessageIndex].content = content;
    }
  }

  delay(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }

  isCodeBlock(content: string): boolean {
    return content.includes('```');
  }

  extractCode(content: string): string {
    const codeMatch = content.match(/```([\s\S]*?)```/);
    return codeMatch ? codeMatch[1] : content;
  }

  stopTypingEffect(){
    this.stopTyping = true;
  }

  splitAndAddResponse(response: string) {
    const segments = response.split(/(```[\s\S]*?```)/g); // Split by code blocks
    segments.forEach(segment => {
      if (segment.startsWith('```') && segment.endsWith('```')) {
        // It's a code block
        this.conversationHistory.push({
          role: 'assistant',
          content: segment.slice(3, -3).trim(),
          isCode: true
        });
      } else if (segment.trim() !== '') {
        // It's a regular text block
        this.conversationHistory.push({
          role: 'assistant',
          content: segment.trim(),
          isCode: false
        });
      }
    });
  }
}
