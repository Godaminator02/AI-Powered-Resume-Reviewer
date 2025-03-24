import os
import io
from fastapi import FastAPI, File, UploadFile
import PyPDF2
import google.generativeai as genai
from dotenv import load_dotenv

# Load API key from .env
load_dotenv()
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

# Ensure API key exists
if not GEMINI_API_KEY:
    raise ValueError("GEMINI_API_KEY is missing. Please check your .env file.")

# Initialize Gemini API
genai.configure(api_key=GEMINI_API_KEY)

app = FastAPI()
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)  # Ensure the directory exists

def analyze_resume_with_gemini(resume_text: str):
    try:
        prompt = f"""
        You are an AI resume expert. Analyze the following resume and provide:
        - A score out of 100 based on clarity, skills, and ATS compatibility.
        - Key strengths of the candidate.
        - Suggested improvements.

        Resume:
        {resume_text}
        """

        # Get available models
        available_models = list(genai.list_models())  # Convert generator to list
        print("Available Models:", [model.name for model in available_models])  # Debugging info

        if not available_models:
            return "Error: No models available. Check your API access."

        # Use the first available model or default to "gemini-pro"
        # Use a supported model for "generate_content"
        model_id = "models/gemini-1.5-pro-latest"

        # Generate response
        model = genai.GenerativeModel(model_id)
        response = model.generate_content(prompt)

        return response.text
    except Exception as e:
        return f"Error analyzing resume: {str(e)}"

@app.post("/upload_resume/")
async def upload_resume(file: UploadFile = File(...)):
    if not file.filename.endswith(".pdf"):
        return {"error": "Only PDF files are allowed"}

    # Read PDF content
    try:
        pdf_reader = PyPDF2.PdfReader(io.BytesIO(await file.read()))
        resume_text = " ".join([page.extract_text() or "" for page in pdf_reader.pages])

        if not resume_text.strip():
            return {"error": "Could not extract text from the resume. Try another file."}

        feedback = analyze_resume_with_gemini(resume_text)

        return {
            "resume_text": resume_text[:500] + "...",  # Truncate resume text for brevity
            "ai_feedback": feedback
        }
    except Exception as e:
        return {"error": f"Failed to process the resume: {str(e)}"}
