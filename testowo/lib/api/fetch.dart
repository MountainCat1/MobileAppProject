// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testowo/api/postDto.dart';

import 'page.dart';
import 'package:http/http.dart' as http;

const catalogLength = 200;


Future<http.Response> fetchPosts(int page, int pageSize) async {
  var uri = Uri.parse("https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$pageSize");

  var response = await http.get(uri);
  return response;
}

Future<ItemPage> fetchPage(int startingIndex, int pageSize) async {
  // We're emulating the delay inherent to making a network call.
  await Future<void>.delayed(const Duration(milliseconds: 500));

  var response = await fetchPosts((startingIndex / pageSize + 1).floor(), pageSize);

  if (response.statusCode != 200) {
    throw const HttpException("Could not retrieve posts data");
  }

  var jsonData = json.decode(response.body);
  var posts = PostDTO.listFromJson(jsonData);

  if (startingIndex > catalogLength) {
    return ItemPage(
      items: [],
      startingIndex: startingIndex,
      hasNext: false,
    );
  }

  // The page of items is generated here.
  return ItemPage(
    items: posts,
    startingIndex: startingIndex,
    // Returns `false` if we've reached the [catalogLength].
    hasNext: posts.length == pageSize,
  );
}


