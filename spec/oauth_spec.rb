# encoding: utf-8
require 'spec_helper'

describe 'OAuth' do

  OAUTH_INITIATE_OPTS = {
    client_id: "client_id",
    redirect_uri: "http://myapp.com/callback",
    scope: "master+releases",
  }.freeze

  OAUTH_CHECKTOKEN_OPTS = {
    grant_type: "authorization_code",
    code: "thecode",
    redirect_uri: "http://myapp.com/callback",
    client_id: "client_id",
    client_secret: "client_secret",
  }

  describe "Public API" do

    PUBLIC_URL = "https://lesbonneschoses.prismic.io/api"

    it "should accept unauthenticated requests" do
      expect {
        Prismic.api(PUBLIC_URL, nil)
      }.not_to raise_error()
    end

    describe "oauth_initiate_url" do

      it "should returns the URL" do
        url = Prismic::API.oauth_initiate_url(PUBLIC_URL, OAUTH_INITIATE_OPTS)
        expected_url = [
          "https://lesbonneschoses.prismic.io/auth?client_id=client_id",
          "redirect_uri=http%3A%2F%2Fmyapp.com%2Fcallback",
          "scope=master%2Breleases",
        ].join("&")
        url.should == expected_url
      end

      it "should returns the URL (with access_token)" do
        url = Prismic.oauth_initiate_url(PUBLIC_URL, OAUTH_INITIATE_OPTS, "token")
        expected_url = [
          "https://lesbonneschoses.prismic.io/auth?client_id=client_id",
          "redirect_uri=http%3A%2F%2Fmyapp.com%2Fcallback",
          "scope=master%2Breleases",
        ].join("&")
        url.should == expected_url
      end

    end

    describe "oauth_check_token" do

      it "should returns the URL" do
        expect {
          Prismic.oauth_check_token(PUBLIC_URL, OAUTH_CHECKTOKEN_OPTS)
        }.to raise_error(
          # we don't want to get a PrismicWSAuthError error here
          Prismic::API::PrismicWSConnectionError,
          "Can't connect to Prismic's API: 400 Bad Request"
        )
      end

    end

  end

  describe "Private API" do

    PRIVATE_URL = "https://privaterepository.prismic.io/api"

    it "should deny unauthenticated requests" do
      expect {
        Prismic.api(PRIVATE_URL, nil)
      }.to raise_error(Prismic::API::PrismicWSAuthError)
    end

    def catch_wserror(url)
      Prismic.api(url, nil)
    rescue Prismic::API::PrismicWSAuthError => e
      e
    end

    it "should provide the error" do
      error = catch_wserror(PRIVATE_URL)
      error.error.should == "Invalid access token"
    end

    it "should provide oauth entry points" do
      error = catch_wserror(PRIVATE_URL)
      error.oauth.initiate.should == "https://privaterepository.prismic.io/auth"
    end

    it "should provide oauth token" do
      error = catch_wserror(PRIVATE_URL)
      error.oauth.token.should == "https://privaterepository.prismic.io/auth/token"
    end

    describe "oauth_initiate_url" do

      it "should returns the URL" do
        url = Prismic.oauth_initiate_url(PRIVATE_URL, OAUTH_INITIATE_OPTS)
        expected_url = [
          "https://privaterepository.prismic.io/auth?client_id=client_id",
          "redirect_uri=http%3A%2F%2Fmyapp.com%2Fcallback",
          "scope=master%2Breleases",
        ].join("&")
        url.should == expected_url
      end

      it "should returns the URL (with access_token)" do
        url = Prismic.oauth_initiate_url(PRIVATE_URL, OAUTH_INITIATE_OPTS, "token")
        expected_url = [
          "https://privaterepository.prismic.io/auth?client_id=client_id",
          "redirect_uri=http%3A%2F%2Fmyapp.com%2Fcallback",
          "scope=master%2Breleases",
        ].join("&")
        url.should == expected_url
      end

    end

    describe "oauth_check_token" do

      it "should returns the URL" do
        expect {
          Prismic::API.oauth_check_token(PRIVATE_URL, OAUTH_CHECKTOKEN_OPTS)
        }.to raise_error(
          # we don't want to get a PrismicWSAuthError error here
          Prismic::API::PrismicWSConnectionError,
          "Can't connect to Prismic's API: 400 Bad Request"
        )
      end

    end

  end

end
