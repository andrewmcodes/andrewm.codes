# Mapping

The mapping gem is a structured system for mapping one model to another, using an intermediate model which represents the transformation to apply.

[![Development Status](https://github.com/ioquatix/mapping/workflows/Test/badge.svg)](https://github.com/ioquatix/mapping/actions?workflow=Test)

## Motivation

I've been thinking (and designing) versioned APIs which serve their data primarily from `ActiveRecord` models. Initially we have been using `as_json/serializable_hash/to_json` where it made sense.

    records.as_json

This was fine for really simple models and APIs. However, as things get more complex, this approach gets cumbersome:

    records.as_json(
    	only: [:id, :name, :image, :longitude, :latitude],
    	include: [:major_category, :categories],
    )

We need versioned, internationalized APIs which don't always directly match up to the underlying database models, or in some cases the underlying models change but the API should remain stable (e.g. column renamed, tables changed).

    # image attribute was renamed to image_url, how do we version the response?
    records.as_json(
    	only: [:id, :name, :image_url, :longitude, :latitude],
    	include: [:major_category, :categories],
    )

It's also not obvious how to inject methods that take arguments, or even handle per-request state (e.g. `Accept-Language`). Even if it is possible (e.g. using a lambda) I'm not sure that this approach is really desirable - the argument list is becoming impossibly complex: Possibly buggy, hard to reuse, test and difficult to document.

[ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers) looks awesome at first but ultimately seems like an over-engineered version of `as_json`. It **directly** depends on globally defined models which makes versioning hard and doesn't provide any obvious way to inject per-request state (e.g. language). It [clutters up existing models and splits serialization concerns over multiple classes](http://programmingisterrible.com/post/139222674273/write-code-that-is-easy-to-delete-not-easy-to-extend). It's implementation is difficult to understand, it has a large surface area, and it doesn't really address the major concerns regarding versioning, stability and (per-request) state.

I've implemented a [framework for Objective-C many years ago](https://github.com/oriontransfer/SWXMLMapping) which exposes a single primary concept: a mapping model. A mapping model is an object which describes the process mapping an input model (e.g. an `ActiveRecord` model) to an output model (e.g. a hash suitable for `JSON::generate`). A mapping model is entirely isolated from state which is not directly related to the mapping process itself. Because of this, multiple models can co-exist, and the models themselves can be versioned, localized, or whatever else necessary to perform a suitable mapping. It's easy to remove a model if it's no longer being used as all the code is in one place. It's easy to test a mapping model in isolation. Models can be documented like normal code. They can be reused and composed together easily.

The design of this library is centered around being explicit where being explicit makes life easier in the long term.

## Installation

Add this line to your application's Gemfile:

    gem 'mapping'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mapping

## Usage

Please see the [project documentation](https://github.com/ioquatix/mapping) for more details.

### Model vs ObjectModel

The base `Mapping::Model` class provides only the basic structure required to create and invoke mapping methods. The `Mapping::ObjectModel` provides a few default mappings for `true`, `false`, `nil`, `Array` and `Hash`.

## Releases

Please see the [project releases](https://github.com/ioquatix/mappingreleases/index) for all releases.

### v1.1.2

  - Improve compatibility issues with Ruby 3+.
  - Migrate test suite to sus and add continuous integration tests.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

In order to protect users of this project, we require all contributors to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
