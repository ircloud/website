Feature: NewsletterUsers API
  In order to intract with newsletter_users from dashboard
  NewsletterUsers API should be accessable by logged in users
  And anonymous user should not have accesss to API

  Scenario: Anonymous User should not have access to API
    Given I am not authenticated
    And there is a newsletter_user named "Iran" in database
    When format is json and I go to the api v1 newsletter_users page
    Then I should get "401" status code
    When format is json and I go to "/api/v1/newsletter_users/1"
    Then I should get "401" status code
    When format is json and I send patch to "/api/v1/newsletter_users/1" with:
    """
    {"email":"OAFSRojXGWeBEalgmCsUQCAiYVEzzSIprlrhIMUIEJtUqLBVaM"}
    """
    Then I should get "401" status code
    When format is json and I send post to "/api/v1/newsletter_users" with:
    """
    {"email":"kAoquFYxStCyTwhGtRcxCEdAiVqewcvSkGKdZjiNVbbLDSRNJo"}
    """
    Then I should get "401" status code
    When format is json and I send delete to "/api/v1/newsletter_users/1"
    Then I should get "401" status code

  Scenario: Default response should be json
    Given I am authenticated
    When I go to the api v1 newsletter_users page
    Then response type should be application/json

  Scenario: Anonymous User via HTTP
    Given I am not authenticated
    When format is html and I go to the api v1 newsletter_users page
    Then I should be in sign in page

  Scenario: Anonymous USer via JSON format
    Given I am not authenticated
    When format is json and I go to the api v1 newsletter_users page
    Then I should get "401" status code

  Scenario: Logged in User via HTTP
    Given I am authenticated
    When format is html and I go to the api v1 newsletter_users page
    Then I should get unknown format exception
    #Then I should get "406" status code

  Scenario: Logged in User via JSON format
    Given I am authenticated
    When format is json and I go to the api v1 newsletter_users page
    Then the JSON should have 0 keys

  Scenario: Logged in User via JSON format And Initial Data
    Given I am authenticated
    And there is a newsletter_user named "XYZ" in database
    When format is json and I go to the api v1 newsletter_users page
    Then the JSON should have 1 keys
    And the JSON at "0/name" should be "XYZ"

  Scenario: API should not response to "/new"
    Given I am authenticated
    When format is json and I go to "/api/v1/newsletter_users/new"
    Then action should not be found

  @javascript
  Scenario: Add New newsletter_user
    Given I am authenticated
    When I go to "/dashboard#/newsletter_users/new"
    And fill in "name" with "XYZ"
    And click on "save"
    And wait for ajax to return
    Then there should be a newsletter_user with "XYZ" as "name"

  @javascript
  Scenario: Edit newsletter_user
    Given I am authenticated
    And there shouldn't be any newsletter_user
    And there is a newsletter_user named "XYZ" in database
    Then there should be a newsletter_user with "XYZ" as "name"
    When I go to "/dashboard#/newsletter_users/1/edit"
    And fill in "name" with "XYZW"
    Then field "name" contains "XYZW"
    When click on "save"
    And wait for ajax to return
    Then there should be a newsletter_user with "XYZW" as "name"

  Scenario: Delete newsletter_user
    Given I am authenticated
    And there is a newsletter_user named "ABC" in database
    And there is a newsletter_user named "XYZ" in database
    When format is json and I send delete to "/api/v1/newsletter_users/1,2"
    Then the JSON at "msg" should be "Items removed successfully."
    And there shouldn't be any newsletter_user
