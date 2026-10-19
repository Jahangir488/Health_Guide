from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health_endpoint():
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json()['clinical_validation'] is False

def test_medicine_search_returns_sample_notice():
    response = client.get('/medicines', params={'q': 'paracetamol'})
    assert response.status_code == 200
    payload = response.json()
    assert len(payload['items']) == 1
    assert payload['items'][0]['source_status'] == 'illustrative_unverified_sample'

def test_urgent_warning_takes_priority_and_no_medicine_is_prescribed():
    response = client.post('/assessments', json={
        'symptom_ids': ['chest_pain'],
        'duration': 'less_than_24_hours',
        'language': 'en',
    })
    assert response.status_code == 200
    payload = response.json()
    assert payload['status'] == 'urgent_care'
    assert payload['diagnosis'] is None
    assert payload['medicine_recommendations'] == []

def test_general_guidance_does_not_diagnose():
    response = client.post('/assessments', json={
        'symptom_ids': ['cough'],
        'duration': '1_2_days',
        'language': 'bn',
    })
    assert response.status_code == 200
    payload = response.json()
    assert payload['status'] == 'general_guidance'
    assert payload['diagnosis'] is None
    assert payload['medicine_recommendations'] == []

def test_unknown_symptom_is_not_silently_accepted():
    response = client.post('/assessments', json={
        'symptom_ids': ['unknown_symptom'],
        'duration': '1_2_days',
        'language': 'en',
    })
    assert response.status_code == 200
    assert response.json()['status'] == 'needs_review'
