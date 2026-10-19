from typing import Literal
from fastapi import FastAPI
from pydantic import BaseModel, Field

app = FastAPI(
    title="Health Guide API",
    version="0.1.0",
    description=(
        "Development prototype for general health information only. "
        "Not a diagnostic or prescribing system. Do not submit real patient data."
    ),
)

WARNING_SIGNS = {
    "severe_difficulty_breathing",
    "chest_pain",
    "fainting_or_loss_of_consciousness",
    "severe_bleeding",
}

SYMPTOMS = [
    {"id": "fever", "name_en": "Fever", "name_bn": "জ্বর"},
    {"id": "cough", "name_en": "Cough", "name_bn": "কাশি"},
    {"id": "headache", "name_en": "Headache", "name_bn": "মাথাব্যথা"},
    {"id": "sore_throat", "name_en": "Sore throat", "name_bn": "গলাব্যথা"},
    {"id": "nausea_vomiting", "name_en": "Nausea or vomiting", "name_bn": "বমি বমি ভাব বা বমি"},
    {"id": "skin_rash", "name_en": "Skin rash", "name_bn": "ত্বকে ফুসকুড়ি"},
    {"id": "severe_difficulty_breathing", "name_en": "Severe difficulty breathing", "name_bn": "তীব্র শ্বাসকষ্ট"},
    {"id": "chest_pain", "name_en": "Chest pain", "name_bn": "বুকে ব্যথা"},
    {"id": "fainting_or_loss_of_consciousness", "name_en": "Fainting or loss of consciousness", "name_bn": "অজ্ঞান হওয়া"},
    {"id": "severe_bleeding", "name_en": "Severe bleeding", "name_bn": "প্রচুর রক্তপাত"},
]

MEDICINES = [
    {
        "id": "sample-paracetamol",
        "generic_name": "Paracetamol",
        "name_bn": "প্যারাসিটামল",
        "general_use": "Commonly used for pain and fever.",
        "safety_note": "Excessive doses can cause serious liver damage. Follow the product label and ask a pharmacist if unsure.",
        "source_status": "illustrative_unverified_sample",
    },
    {
        "id": "sample-ors",
        "generic_name": "Oral rehydration salts (ORS)",
        "name_bn": "খাবার স্যালাইন (ORS)",
        "general_use": "Replaces fluids and electrolytes lost through diarrhoea or dehydration.",
        "safety_note": "Prepare exactly as the packet directs. Severe dehydration needs urgent medical assessment.",
        "source_status": "illustrative_unverified_sample",
    },
    {
        "id": "sample-ibuprofen",
        "generic_name": "Ibuprofen",
        "name_bn": "আইবুপ্রোফেন",
        "general_use": "An anti-inflammatory pain reliever.",
        "safety_note": "May be unsuitable with stomach ulcers, kidney problems, some medicines, or during pregnancy. Ask a qualified professional.",
        "source_status": "illustrative_unverified_sample",
    },
]

class AssessmentRequest(BaseModel):
    symptom_ids: list[str] = Field(min_length=1, max_length=30)
    duration: Literal["less_than_24_hours", "1_2_days", "3_7_days", "more_than_7_days"]
    language: Literal["en", "bn"] = "en"

@app.get("/health")
def health():
    return {"status": "ok", "prototype": True, "clinical_validation": False}

@app.get("/symptoms")
def get_symptoms():
    return {"items": SYMPTOMS}

@app.get("/medicines")
def get_medicines(q: str | None = None):
    items = MEDICINES
    if q:
        needle = q.casefold()
        items = [m for m in MEDICINES if needle in m["generic_name"].casefold() or needle in m["name_bn"]]
    return {"items": items, "notice": "Illustrative sample entries; not verified for clinical use."}

@app.post("/assessments")
def assess(request: AssessmentRequest):
    known_ids = {item["id"] for item in SYMPTOMS}
    unknown = sorted(set(request.symptom_ids) - known_ids)
    if unknown:
        return {
            "status": "needs_review",
            "message": "One or more symptom IDs are not recognized. Please review your answers.",
            "unknown_symptom_ids": unknown,
            "diagnosis": None,
            "medicine_recommendations": [],
        }
    urgent = bool(set(request.symptom_ids) & WARNING_SIGNS)
    if request.language == "bn":
        message = (
            "নির্বাচিত সতর্কতামূলক লক্ষণ জরুরি অবস্থা হতে পারে। এখনই জরুরি চিকিৎসা নিন; অ্যাপের জন্য অপেক্ষা করবেন না।"
            if urgent else
            "শুধু এই তথ্য দিয়ে রোগের কারণ নির্ধারণ করা যায় না। উপসর্গ গুরুতর, বাড়তে থাকা বা দীর্ঘস্থায়ী হলে চিকিৎসকের পরামর্শ নিন।"
        )
    else:
        message = (
            "A selected warning symptom may be an emergency. Seek emergency medical care now; do not wait for this app."
            if urgent else
            "These answers cannot establish the cause. Seek medical advice if symptoms are severe, worsening, persistent, or concerning."
        )
    return {
        "status": "urgent_care" if urgent else "general_guidance",
        "message": message,
        "selected_symptom_ids": request.symptom_ids,
        "duration": request.duration,
        "diagnosis": None,
        "medicine_recommendations": [],
        "prototype_notice": "Not clinically validated. Absence of listed warning signs does not establish safety.",
    }
