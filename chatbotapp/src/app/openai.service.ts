import { Injectable } from '@angular/core';
import axios from "axios";

@Injectable({
  providedIn: 'root'
})
export class OpenaiService {

  public myModel: string = 'gpt-4o-mini';
  private apiUrl = 'https://api.openai.com/v1/chat/completions';

  private envApiKey: string = '<PUT_YOUR_OPENAI_API_HERE>';

  private conversation: {role: string, content: string} [] = [];

  constructor() { }

  async getChatResponse(prompt: string): Promise<string> {
    this.conversation.push({role: 'user', content: prompt});

    try {
      const response = await axios.post(this.apiUrl, {
        model: this.myModel, // or another model you're using
        messages: this.conversation
      }, {
        headers: {
          'Authorization': `Bearer ${this.envApiKey}`,
          'Content-Type': 'application/json'
        }
      });

      const botMessage = response.data.choices[0].message.content;

      this.conversation.push({role: 'assistant', content: botMessage});
      return botMessage;
    } catch (error) {
      console.error('Error calling OpenAI API', error);
      throw error;
    }
  }
}
