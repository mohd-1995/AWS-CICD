from flask import Flask, render_template, request, redirect
import sqlite3
import os

app = Flask(__name__)

# Load configuration from environment variables
DEBUG_MODE = os.getenv("DEBUG_MODE", "True").lower() == "true"
HOST = os.getenv("HOST", "0.0.0.0")
PORT = int(os.getenv("PORT", 5000))
DATABASE_PATH = os.getenv("DATABASE_PATH", "/data/portfolio_contacts.db")


def init_db():
    with sqlite3.connect('portfolio_contacts.db') as conn:
        cursor = conn.cursor()
        cursor.execute('''
                    CREATE TABLE IF NOT EXISTS contacts (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        email TEXT NOT NULL,
                        phone TEXT NOT NULL,
                        ip TEXT,
                        user_agent TEXT, 
                        submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                    )
                ''')
        conn.commit()

#render my html file.
@app.route('/')
def home():
    return render_template('index.html')


@app.route('/api/submit', methods=['POST'])
def submit():
    name = request.form.get('name')
    email = request.form.get('email')
    phone = request.form.get('phone')

    user_ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    user_agent = request.headers.get('User-Agent')

    if name and email and phone:
        with sqlite3.connect('portfolio_contacts.db') as conn:
            cursor = conn.cursor()
            cursor.execute("INSERT INTO contacts (name, email, phone, ip, user_agent)  VALUES(?,?,?,?,?)",
                           (name, email, phone, user_ip, user_agent))

            conn.commit()
        return redirect('/')
    else:
        return 'Please fill in all the fields', 400


if __name__ == '__main__':
    init_db()
    app.run(debug=True, host=HOST, port=PORT)

###