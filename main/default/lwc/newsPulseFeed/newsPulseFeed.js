import { LightningElement, wire, track } from 'lwc';
import getNews from '@salesforce/apex/NewsAPIService.getLatestNews';
import fetchNews from '@salesforce/apex/NewsAPIService.fetchNews';
import { refreshApex } from '@salesforce/apex';

export default class NewsPulseFeed extends LightningElement {
    @track groupedArticles = [];
    @track totalArticles = 0;
    wiredResult;

    @wire(getNews)
    wiredNews(result) {
        this.wiredResult = result;
        const { error, data } = result;
        if (data) {
            this.totalArticles = data.length;

            const categoryMap = new Map();
            data.forEach(item => {
                const cat = item.Category__c || 'General';
                if (!categoryMap.has(cat)) {
                    categoryMap.set(cat, []);
                }
                categoryMap.get(cat).push(item);
            });

            this.groupedArticles = Array.from(categoryMap.entries())
                .sort((a, b) => a[0].localeCompare(b[0]))
                .map(([category, articles]) => ({
                    category,
                    articles
                }));
        } else if (error) {
            console.error('Error loading news:', error);
        }
    }

    handleFetch() {
        fetchNews()
            .then(() => {
                return refreshApex(this.wiredResult);
            })
            .catch(error => {
                console.error('Fetch failed:', error);
            });
    }
}
