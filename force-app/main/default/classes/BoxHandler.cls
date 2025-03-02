public class BoxHandler { 
    @AuraEnabled
    public static String uploadFile(Blob base64, String filename, String folderId){
        if(base64!=null){

            if(folderId == ''){
                folderId = '0';
            }

            blob base64EncodeFile = base64EncodeFileContent(base64, filename);
            String uploadEndPointURL='callout:BoxUpload/api/2.0/files/content?parent_id='+folderId;
            String boundary = '----------------------------741e90d31eff';

            HttpRequest req = new HttpRequest();
            req.setBodyAsBlob(base64EncodeFile);
            req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
            req.setMethod('POST');
            req.setEndpoint(uploadEndPointURL);
            req.setTimeout(120000);
            Http ht = new Http();
            HTTPResponse res = ht.send(req);

            Integer uploadStatusCode = res.getStatusCode();

            if(uploadStatusCode >= 200 && uploadStatusCode < 300){
                return 'File uploaded successfully.';
            }
        }
        return null;
    }
    
    private static Blob base64EncodeFileContent(Blob file_body, String file_name){
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="file"; filename="'+file_name+'";\nContent-Type: application/octet-stream';
        String footer = '--'+boundary+'--';             
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));

        while(headerEncoded.endsWith('=')) {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }

        String bodyEncoded = EncodingUtil.base64Encode(file_body);
        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        if(last4Bytes.endsWith('==')) {
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);              
        } else {
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);  
        }
        
        return bodyBlob;
    } 
}