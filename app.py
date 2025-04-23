from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
from mysql.connector import Error

app = Flask(__name__)

def create_connection():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            port=3306,
            database='Books',  # Update with your actual database name
            user='root',  # Your MySQL username
            password='GobJuinws24Xz*'  # Your MySQL password
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error: {e}")
        return None
#try change
# main page
@app.route('/')
def index():
    return render_template('index.html')

# Author Routes
@app.route('/authors')
def authors():
    connection = create_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT * FROM Authors")
    authors = cursor.fetchall()
    connection.close()
    return render_template('authors.html', authors=authors)

@app.route('/create_author', methods=['POST'])
def create_author():
    name = request.form['name']
    birth_year = request.form['birth_year']
    connection = create_connection()
    cursor = connection.cursor()
    query = "INSERT INTO Authors (name, birth_year) VALUES (%s, %s)"
    cursor.execute(query, (name, birth_year))
    connection.commit()
    connection.close()
    return redirect(url_for('authors'))

@app.route('/delete_author/<int:author_id>')
def delete_author(author_id):
    connection = create_connection()
    cursor = connection.cursor()

    try:
        # First, delete any entries in the borrowedbooks table that reference books by this author
        cursor.execute("DELETE FROM borrowedbooks WHERE book_id IN (SELECT id FROM Books WHERE author_id = %s)", (author_id,))
        
        # Now delete the books by this author
        cursor.execute("DELETE FROM Books WHERE author_id = %s", (author_id,))
        
        # Finally, delete the author
        query = "DELETE FROM Authors WHERE id = %s"
        cursor.execute(query, (author_id,))
        
        # Commit the changes
        connection.commit()
    except mysql.connector.Error as err:
        print(f"Error: {err}")
        connection.rollback()  # Rollback in case of an error
    finally:
        cursor.close()
        connection.close()
    
    return redirect(url_for('authors'))

@app.route('/update_author', methods=['POST'])
def update_author():
    author_id = request.form['author_id']
    name = request.form['name']
    birth_year = request.form['birth_year']
    connection = create_connection()
    cursor = connection.cursor()
    query = "UPDATE Authors SET name = %s, birth_year = %s WHERE id = %s"
    cursor.execute(query, (name, birth_year, author_id))
    connection.commit()
    connection.close()
    return redirect(url_for('authors'))

# Book Routes
@app.route('/books')
def books():
    connection = create_connection()
    cursor = connection.cursor()
    
    # Fetch all authors to populate the dropdown
    cursor.execute("SELECT id, name FROM Authors")
    authors = cursor.fetchall()
    
    # Join Books and Authors to get the author's name
    cursor.execute("""
        SELECT Books.id, Books.title, Authors.name, Books.published_year
        FROM Books
        JOIN Authors ON Books.author_id = Authors.id
    """)
    books = cursor.fetchall()
    connection.close()
    return render_template('books.html', books=books, authors=authors)

@app.route('/create_book', methods=['POST'])
def create_book():
    title = request.form['title']
    author_id = request.form['author_id']
    published_year = request.form['published_year']
    connection = create_connection()
    cursor = connection.cursor()
    query = "INSERT INTO Books (title, author_id, published_year) VALUES (%s, %s, %s)"
    cursor.execute(query, (title, author_id, published_year))
    connection.commit()
    connection.close()
    return redirect(url_for('books'))

@app.route('/delete_book/<int:book_id>')
def delete_book(book_id):
    connection = create_connection()
    cursor = connection.cursor()
    query = "DELETE FROM Books WHERE id = %s"
    cursor.execute(query, (book_id,))
    connection.commit()
    connection.close()
    return redirect(url_for('books'))

# Borrower Routes
@app.route('/borrowers')
def borrowers():
    connection = create_connection()
    cursor = connection.cursor()
    
    # Fetch all borrowers
    cursor.execute("SELECT * FROM Borrowers")
    borrowers = cursor.fetchall()
    
    # Fetch available books to populate the dropdown
    cursor.execute("SELECT id, title FROM Books")
    books = cursor.fetchall()
    
    connection.close()
    return render_template('borrowers.html', borrowers=borrowers, books=books)

@app.route('/create_borrower', methods=['POST'])
def create_borrower():
    name = request.form['name']
    contact_info = request.form.get('contact_info', '')  # Use get to avoid KeyError
    connection = create_connection()
    cursor = connection.cursor()
    query = "INSERT INTO Borrowers (name, contact_info) VALUES (%s, %s)"
    cursor.execute(query, (name, contact_info))
    connection.commit()
    connection.close()
    return redirect(url_for('borrowers'))

@app.route('/delete_borrower/<int:borrower_id>')
def delete_borrower(borrower_id):
    connection = create_connection()
    cursor = connection.cursor()
    query = "DELETE FROM Borrowers WHERE id = %s"
    cursor.execute(query, (borrower_id,))
    connection.commit()
    connection.close()
    return redirect(url_for('borrowers'))

@app.route('/borrow_book', methods=['POST'])
def borrow_book():
    borrower_id = request.form['borrower_id']
    book_id = request.form['book_id']
    borrow_date = request.form['borrow_date']
    connection = create_connection()
    cursor = connection.cursor()
    query = "INSERT INTO BorrowedBooks (borrower_id, book_id, borrow_date) VALUES (%s, %s, %s)"
    cursor.execute(query, (borrower_id, book_id, borrow_date))
    connection.commit()
    connection.close()
    return redirect(url_for('borrowers'))

@app.route('/return_book/<int:borrowed_book_id>')
def return_book(borrowed_book_id):
    connection = create_connection()
    cursor = connection.cursor()
    query = "DELETE FROM BorrowedBooks WHERE id = %s"
    cursor.execute(query, (borrowed_book_id,))
    connection.commit()
    connection.close()
    return redirect(url_for('borrowers'))

# Query for book count using COUNT and LEFT JOIN
@app.route('/author_book_count')
def author_book_count():
    connection = create_connection()
    cursor = connection.cursor()
    query = """
        SELECT a.name AS author_name, COUNT(b.id) AS total_books
        FROM Authors AS a
        LEFT JOIN Books AS b ON a.id = b.author_id
        GROUP BY a.name;
    """
    cursor.execute(query)
    counts = cursor.fetchall()
    connection.close()
    return render_template('author_book_count.html', author_book_counts=counts)

# Avg
@app.route('/author_avg_year')
def author_avg_year():
    connection = create_connection()
    cursor = connection.cursor()
    query = """
        SELECT a.name AS author_name, AVG(b.published_year) AS avg_year
        FROM Authors AS a
        LEFT JOIN Books AS b ON a.id = b.author_id
        GROUP BY a.name;
    """
    cursor.execute(query)
    averages = cursor.fetchall()
    connection.close()
    return render_template('author_avg_year.html', averages=averages)

# Borrower Route
@app.route('/borrower_book_count')
def borrower_book_count():
    connection = create_connection()
    cursor = connection.cursor()
    query = """
        SELECT b.name AS borrower_name, COUNT(bb.book_id) AS total_books_borrowed
        FROM Borrowers AS b
        LEFT JOIN BorrowedBooks AS bb ON b.id = bb.borrower_id
        GROUP BY b.id;
    """
    cursor.execute(query)
    counts = cursor.fetchall()
    connection.close()
    return render_template('borrower_book_count.html', counts=counts)

# Avg
@app.route('/avg_books_per_author')
def avg_books_per_author():
    connection = create_connection()
    cursor = connection.cursor()
    query = """
        SELECT AVG(book_count) AS avg_books_per_author
        FROM (
            SELECT COUNT(b.id) AS book_count
            FROM Authors AS a
            LEFT JOIN Books AS b ON a.id = b.author_id
            GROUP BY a.id
        ) AS author_counts;
    """
    cursor.execute(query)
    avg_count = cursor.fetchone()[0]  # Fetch the average count
    connection.close()
    return render_template('avg_books_per_author.html', avg_books=avg_count)

# Borrowed books
@app.route('/borrowed_books')
def borrowed_books():
    connection = create_connection()
    cursor = connection.cursor()

    # Fetch borrowed books with borrower information
    query = """
        SELECT bb.id, b.title, br.name, bb.borrow_date
        FROM BorrowedBooks AS bb
        JOIN Books AS b ON bb.book_id = b.id
        JOIN Borrowers AS br ON bb.borrower_id = br.id
    """
    cursor.execute(query)
    borrowed_books = cursor.fetchall()
    connection.close()
    return render_template('borrowed_books.html', borrowed_books=borrowed_books)


if __name__ == '__main__':
    app.run(debug=True)