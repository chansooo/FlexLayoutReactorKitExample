//
//  Show.swift
//  flexlayout-test
//
//  Created by kimchansoo on 2023/01/02.
//

import Foundation

struct Series {
    let image = "sherlock"
    let showPopularity = 5
    let showYear = "2010"
    let showRating = "TV-14"
    let showLength = "3 Series"
    let selectedShow = "S3:E3"
    let showCast = "Benedict Cumberbatch, Martin Freeman, Una Stubbs"
    let showCreators = "Mark Gatiss, Steven Moffat"
    
    let shows: [Show]
}

struct Show {
    let title: String
    let length: String
    let detail: String
    let image: String
    let showPopularity = 5
}
