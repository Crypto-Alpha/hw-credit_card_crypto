# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

describe 'Test hashing requirements' do
  describe 'Test regular hashing' do
    describe 'Check hashes are consistently produced' do
      cards.each do |test_card|
        describe "The card is held by #{test_card.owner} and the bank of the card is #{test_card.credit_network}" do
          # TODO: Check that each card produces the same hash if hashed repeatedly
          # Choose first test card as test card and hash repeatedly
          it 'should produce same hash every time when the input serialize content is the same' do
            # Repeat three times
            hash_arr = (1..3).map { test_card.hash }
            # Check the hash result isn't nil
            _(hash_arr.any?(&:nil?)).must_equal false
            # Check the hash element are the same
            _(hash_arr.uniq.size.to_s).must_equal 1.to_s
          end
        end
      end
    end

    describe 'Check for unique hashes' do
      # TODO: Check that each card produces a different hash than other cards
      test_hashes = cards.map(&:hash)
      it 'should produce different hash when the input serialize content is not the same' do
        # Check the hash result isn't nil
        _(test_hashes.any?(&:nil?)).must_equal false
        # Check the hash result are the different
        _(test_hashes.uniq.size.to_s).must_equal test_hashes.length.to_s
      end
    end
  end

  describe 'Test cryptographic hashing' do
    describe 'Check hashes are consistently produced' do
      # TODO: Check that each card produces the same hash if hashed repeatedly
      cards.each do |test_card|
        describe "The card is held by #{test_card.owner} and the bank of the card is #{test_card.credit_network}" do
          # TODO: Check that each card produces the same hash if hashed repeatedly
          it 'should produce same hash every time when the input serialize content is the same' do
            # Repeat three times
            hash_arr = (1..3).map { test_card.hash_secure }
            # Check the hash result isn't nil
            _(hash_arr.any?(&:nil?)).must_equal false
            # Check the hash element are the same
            _(hash_arr.uniq.size.to_s).must_equal 1.to_s
          end
        end
      end
    end

    describe 'Check for unique hashes' do
      # TODO: Check that each card produces a different hash than other cards
      test_hashes = cards.map(&:hash_secure)
      it 'should produce different hash when the input serialize content is not the same' do
        # Check the hash result isn't nil
        _(test_hashes.any?(&:nil?)).must_equal false
        # Check the hash result are the different
        _(test_hashes.uniq.size.to_s).must_equal test_hashes.length.to_s
      end
    end

    describe 'Check regular hash not same as cryptographic hash' do
      cards.each do |test_card|
        describe "The card is held by #{test_card.owner} and the bank of the card is #{test_card.credit_network}" do
          # TODO: Check that each card's hash is different from its hash_secure
          it 'should produce different hash result of regular hash & cryptographic hash' do
            # produce a regular hash
            reg_hash = test_card.hash
            crypto_hash = test_card.hash_secure
            # Check the reg hash result isn't nil
            _(reg_hash).wont_equal nil
            # Check the crypto hash result isn't nil
            _(crypto_hash).wont_equal nil
            # Check the hash element are the same
            _(reg_hash).wont_equal crypto_hash
          end
        end
      end
    end
  end
end
