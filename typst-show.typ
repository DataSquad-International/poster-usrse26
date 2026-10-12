#show: doc => poster(
  $if(title)$ title: [$title$], $endif$
  $if(poster-authors)$ authors: [$poster-authors$], $endif$
  $if(poster-affiliations)$ affiliations: [$poster-affiliations$], $endif$
  $if(size)$ size: "$size$", $endif$
  $if(poster-logo)$ logo: "$poster-logo$", $endif$
  $if(footer-text)$ footer-text: [$footer-text$], $endif$
  $if(footer-url)$ footer-url: [$footer-url$], $endif$
  $if(num-columns)$ num-columns: $num-columns$, $endif$
  doc,
)
