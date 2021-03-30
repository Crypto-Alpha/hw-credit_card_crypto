# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require_relative '../sk_cipher'
require 'minitest/autorun'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
    @key = 3
    @sk_cipher_key = ModernSymmetricCipher.generate_new_key

    @cipher_enc = {
      'Caesar' => SubstitutionCipher::Caesar.encrypt(@cc, @key),
      'Permutation' => SubstitutionCipher::Permutation.encrypt(@cc, @key),
      'Double_Transposition' => DoubleTranspositionCipher.encrypt(@cc, @key),
      'Modern_Symmetric' => ModernSymmetricCipher.encrypt(@cc, @sk_cipher_key)
    }

    @cipher_dec = {
      'Caesar' => SubstitutionCipher::Caesar.decrypt(@cipher_enc['Caesar'], @key),
      'Permutation' => SubstitutionCipher::Permutation.decrypt(@cipher_enc['Permutation'], @key),
      'Double_Transposition' => DoubleTranspositionCipher.decrypt(@cipher_enc['Double_Transposition'], @key),
      'Modern_Symmetric' => ModernSymmetricCipher.decrypt(@cipher_enc['Modern_Symmetric'], @sk_cipher_key)
    }
  end

  %w[Caesar Permutation Double_Transposition Modern_Symmetric].each do |cipher|
    describe "Using #{cipher} cipher" do
      it 'should encrypt card information' do
        enc = @cipher_enc[cipher]
        _(enc).wont_equal @cc.to_s
        _(enc).wont_be_nil
      end

      it 'should decrypt text' do
        dec = @cipher_dec[cipher]
        _(dec).must_equal @cc.to_s
      end
    end
  end
end
