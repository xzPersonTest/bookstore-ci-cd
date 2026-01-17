def test_addition():
    assert 1 + 1 == 2

def test_home_endpoint():
    from app import app
    with app.test_client() as client:
        response = client.get('/')
        assert response.status_code == 200
        assert b"Bookstore API" in response.data
