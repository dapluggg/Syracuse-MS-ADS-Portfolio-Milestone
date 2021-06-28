


CountryYear <- read.csv('/Users/shashanknagaraja/Library/Mobile Documents/com~apple~CloudDocs/Syracuse/IST 652 Scripting/week4/HW1/output/country_vs_release_year.csv',
                        header = T)


colnames(CountryYear) = gsub('X', '', colnames(CountryYear))
rownames(CountryYear) <- CountryYear$country
CountryYear$country <- NULL
heatmap(as.matrix(CountryYear), 
        scale = "column",
        Colv = NA)

sum(colSums(CountryYear))
tmp <- as.data.frame(t(CountryYear)) 
barplot(tmp$`United States`,
        names.arg = rownames(tmp),
        xlab = "Release Year",
        ylab = "# Movies Available on Netflix",
        main = "Netflix Movies by Release Date",
        col = '#E50914')

GenreYear <- read.csv('/Users/shashanknagaraja/Library/Mobile Documents/com~apple~CloudDocs/Syracuse/IST 652 Scripting/week4/HW1/listed_in_vs_release_year.csv',
                      header = T)
colnames(GenreYear) = gsub('X', '', colnames(GenreYear))
rownames(GenreYear) <- GenreYear$listed_in
GenreYear$listed_in <- NULL
heatmap(as.matrix(GenreYear), 
        scale = "row",
        Colv = NA,
        main = "")

date_added_toNetflix <- read.csv('/Users/shashanknagaraja/Library/Mobile Documents/com~apple~CloudDocs/Syracuse/IST 652 Scripting/week4/HW1/output/date_added_toNetflix.csv',
                                 header = T)
date_added_toNetflix <- date_added_toNetflix[order(date_added_toNetflix$year),]
date_added_toNetflix <- date_added_toNetflix[complete.cases(date_added_toNetflix$year),]
barplot(date_added_toNetflix$total, names.arg = date_added_toNetflix$year,
        main = 'Titles added to Netflix',
        xlab = 'Year',
        ylab = '# of Titles added')

pie(list(netflix_titles$rating))

pie(table(netflix_titles$rating), radius = 1) 

library(wordcloud2)
wordcloud2(netflix_titles$description)

mywords <- ""
for (i in netflix_titles$description) {
        mywords <- paste(i, mywords, sep = " ")
}
library(tm)
mywords <- Corpus(VectorSource(mywords))
mywords <- tm_map(mywords, removeWords, stopwords("english"))
mywords <- tm_map(mywords, tolower)
inspect(mywords)
mywords <- as.matrix(mywords)
tdm <- TermDocumentMatrix(mywords)
wordcloud::wordcloud(mywords, colors=brewer.pal(8, "Dark2"), max.words=200)


