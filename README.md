# newsman

Command Line Tool for Newspaper Layout

usage 

```ruby
usgage
	newsman new_publication [publication_path] [publication_name]
	newsman new_issue [publication_path] [issue_date]
	newsman section_pdf [section_path] 
	newsman change_section_layout [section_path] [grid_key]
	newsman update_section_layout [section_path]
	newsman story_pdf [story_path]

 example:
 	newsman new_publication my_publication/path OurTownNews
  	newsman new_issue my_publication/path 2015-5-10
  	newsman section_pdf my_news_section/path 
  	newsman change_section_layout my_news_section/path 7x12/6
  	newsman update_section_layout my_news_section/path
  	newsman story_pdf my_news_story/path/1.story.md
```

