public with sharing class NewsAPIService {

    public class Article {
        public String title;
        public String description;
        public String url;
        public String image_url;
        public String published_at;
        public String source;
        public String snippet;
        public List<String> categories = new List<String>(); 
    }

    public class NewsWrapper {
        public List<Article> data;
    }
    @AuraEnabled
    public static void fetchNews() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:NewsPulse/getNews'); // Named Credential endpoint
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            System.debug('Response: ' + res.getBody());

            NewsWrapper newsData = (NewsWrapper) JSON.deserialize(res.getBody(), NewsWrapper.class);
            List<NewsPulse__c> newsRecords = new List<NewsPulse__c>();

            for (Article a : newsData.data) {
                String cat = (a.categories != null && a.categories.size() > 0)
                    ? a.categories[0]
                    : 'General';

                newsRecords.add(new NewsPulse__c(
                    Title__c = a.title,
                    Description__c = a.description,
                    URL__c = a.url,
                    Image_URL__c = a.image_url,
                    Published_Date__c = DateTime.valueOf(a.published_at.substring(0, 19).replace('T', ' ')),
                    Source_Name__c = a.source,
                    snippet__c = a.snippet,
                    Category__c = cat
                ));
            }

            insert newsRecords;
        } else {
            System.debug('Callout failed. Status: ' + res.getStatusCode());
            System.debug('Body: ' + res.getBody());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<NewsPulse__c> getLatestNews() {
        return [
            SELECT Id, Title__c, URL__c, Description__c, Source_Name__c, Published_Date__c, Category__c,snippet__c
            FROM NewsPulse__c
            ORDER BY Published_Date__c DESC
            LIMIT 50
        ];
    }
}