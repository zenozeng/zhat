echo "POSTS TESTS ===================="
echo "ADD POST"
http -f POST 127.0.0.1:8080/posts content=HelloWorld
echo "GET POST"
http 127.0.0.1:8080/posts/1
echo "UPDATE POST"
http -f POST 127.0.0.1:8080/posts/1 content=PostUpdated
echo "GET POST (again)"
http 127.0.0.1:8080/posts/1
echo "GET POSTS"
http 127.0.0.1:8080/posts

echo "COMMENTS TEST ===================="
http -f POST 127.0.0.1:8080/comments content=HelloWorld pid=1

echo "FILES TEST ===================="
echo "ADD FILE TEST"
http -f POST 127.0.0.1:8080/files content=HelloWorld
echo "GET FILE TEST"
http 127.0.0.1:8080/files/1
echo "GET FILE 404 TEST"
http 127.0.0.1:8080/files/1000000
