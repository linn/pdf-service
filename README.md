An instance of [gotenberg](https://gotenberg.dev/docs/about) hosted at app.linn.co.uk/pdf-service.

The primary use case is converting html files to pdf via a POST to the /convert/html endpoint: 
```
curl --request POST \
    --url http://app.linn.co.uk/pdf-service/convert/html \
    --header 'Content-Type: multipart/form-data' \
    --form files=@index.html \
    -o result.pdf
```

Sample C# Http Request as follows:

```cs
public async Task<Stream> ConvertHtmlToPdf(string html)
{
    using (var client = new HttpClient())
    {
        using (var multiPartStream = new MultipartFormDataContent())
        {
            var bytes = Encoding.UTF8.GetBytes(html);
               
            multiPartStream.Add(
                new ByteArrayContent(bytes, 0, bytes.Length), 
                "files", 
                "index.html");
                                        
            var request =
                new HttpRequestMessage(HttpMethod.Post, "http://app.linn.co.uk/pdf-service/convert/html")
                {
                    Content = multiPartStream
                };

            var response = await client.SendAsync(
                                   request, 
                                   HttpCompletionOption.ResponseContentRead);
                                   
            var res = await response.Content.ReadAsStreamAsync();
            return res;
        }
    }
}
```
