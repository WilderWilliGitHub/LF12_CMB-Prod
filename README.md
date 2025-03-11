# Dokumentation für LF12_CMB-Prod. Projekt

# 1. chatbotapp
## How the app made:
### Step 1. Install Node.js and npm (Node Package Manager)
Angular requires Node.js and npm (Node Package Manager).
1. Download Node.js
   * Go to Node.js website
   * Download the LTS version for your operating system
   * Install it using the default settings.
2. Verify the installation
   * Open Command Promt (Windows) or Terminal (Mac/Linux) and run:
   ```
   node -v
   npm -v
   ```
   It should show installed Node.js and npm

### Step 2. Install Angular CLI
The angular CLI (Command Line Interface) helps create and manage Angular projects
1. Open Command Promt (Windows) or Terminal (Mac/Linux)
2. Run following command:
   ```
   npm install -g @angular/cli
   ```
   The `-g` flag installs it globally.
3. Verify the installation
   ```
   ng version
   ```
   Installed Angular version should be shown

### Step 3. Create a New Angular Project
1. Navigate to the folder where you want to create your project:
   ```
   cd path/to/project/folder
   ```
2. Create a new project:
   ```
   ng new chatbotapp
   ```
   * choose CSS
3. Navigate to the project folder:
   ```
   cd chatbotapp
   ```

### Step 4. Run the Angular Application to try
1. Start the development server:
   ```
   ng serve
   ```
2. Try on browser. Open browser and go to:
   ```
   http://localhost:4200
   ```
   Angular default page should be shown.

### Step 5. Prepare OpenAI API calling
1. Get the api endpoint, for example:
   ```
   https://api.openai.com/v1/chat/completions
   ```
2. Choose model, for example:
   ```
   gpt-4o-mini
   ```
3. Get API key to use in the app.

### Step 6. Use the API Key for the chatbot app (simplified)
1. Create a chat component:
   ```
   ng generate component chat
   ```
   * work with it to create chat component
2. Create a navbar component:
   ```
   ng generate component navbar
   ```
   * work with it to create navbar
3. Generate openAI service component:
   ```
   ng generate service openai
   ```
   * work with it to create service that connect to openAI API

### Step 7. Deploy to Raspberry pi
.tar image file need to be on raspberry
#### Prerequisites:
1. **SSH Access:** Ensure SSH to Raspberry pi
2. **Docker installed and run on Raspberry Pi**
3. **Docker installed and run on Local Machine**
4. **Build Angular Project**

#### Steps to Deploy
1. **Build the Angular Project**
   * on Local Machine, navigate to Angular project directory and run:
   ```
   ng build --prod
   ```
   * this will generate a `dist/` folder containing the production-ready files.
2. **Create a Dockerfile**
   * In the root of Angular project (where the `dist/` folder is located), create a file named `Dockerfile` with the following content:
   ```
   # Use an official Ngix image as a parent image
   FROM nginx:alpine
   
   # Copy the Angular build output to the Nginx html directory
   COPY ./dist/chatbotapp /usr/share/nginx/html

   # Expose port 80
   EXPOSE 80

   # Start Nginx
   CMD ["nginx", "-g", "daemon off;"]
   ```
3. **Build the Docker Image**
   * In terminal run the command to build Docker image für arm64:
   ```
   docker build --platform linux/arm64 -t chatbotapp .
   ```
4. **Save the Docker Image**
   * Save Docker image to tar file to send it to Pi:
   ```
   docker save -o chatbotapp.tar chatbotapp
   ```
5. **Transfer the Docker Image to Raspberry Pi**
   * Use SCP (Secure Copy Protocol) to transfer the image to your Raspberry Pi (for example):
   ```
   scp -i ".\eka_privatekey_openssh" chatbotapp-arm.tar cmb@192.168.88.100:/home/cmb/Docker chatbotapp-arm.tar
   ```
6. **Load Docker Image on Raspberry Pi**
   * SSH to Raspberry Pi:
   ```
   ssh -i ".\eka_privatekey_openssh" cmb@192.168.88.100
   ```
   * Load the Docker image:
   ```
   docker load -i chatbotapp-arm.tar
   ```
7. **Run the Docker Container**
   * Run the Docker container on Raspberry Pi:
   ```
   docker run -d -p 80:80 chatbotapp-arm
   ```
8. **Access Angular App**
   * Open web Browser and navigate to `http://192.168.88.100:8080` to see the app  
