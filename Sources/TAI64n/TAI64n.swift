import Foundation
import RegexBuilder

@available(macOS 13, iOS 16, tvOS 16, watchOS 9, *)
extension Date {
	
	static var taiT0: UInt64 {
		get { 4_611_686_018_427_387_914 }
	}
	public init?(tai64nLabel: String) {
		let str = tai64nLabel

		let labelregex = Regex {
			Optionally("@")
			TryCapture {
				Repeat(.hexDigit, count: 16)
			} transform: {
				UInt64($0, radix: 16)
			}
			TryCapture {
				Repeat(.hexDigit, count: 8)
			} transform: {
				UInt32($0, radix: 16)
			}
		}
		
		if let match = str.wholeMatch(of: labelregex ) {
			var seconds: Int64
			var nanos: UInt32
			nanos = match.output.2
			if match.output.1 < Date.taiT0 {
				seconds = Int64( Date.taiT0 - match.output.1 )
				seconds.negate()
			} else {
				seconds = Int64(match.output.1 - Date.taiT0)
			}
			var big_d: TimeInterval = TimeInterval(seconds)
			big_d += TimeInterval( nanos ) / TimeInterval(1_000_000_000.0)
			self = Date(timeIntervalSince1970: big_d)
		} else {
			return nil
		}
	}
	
	public var tai64nlabel: String {
		get {
			let epoch = self.timeIntervalSince1970
			let billion: TimeInterval = TimeInterval(1_000_000_000.0)
			var fractions: Int = Int((
				epoch.truncatingRemainder(dividingBy: 1.0 ) * billion
			).rounded())
			var t0 = Date.taiT0
			if epoch < 0.0 {
				var working_sec = Int64( epoch )
				working_sec.negate()
				t0 -= UInt64(working_sec)
					/// When the epoch is negative, the fractional part has to be inverted and the second decremented
					/// The first 16 bytes of a label are the begining of the second and the fraction adds to that.
					/// All TAI64 timestamps are positive, epochs are often negative when referring to historical
					/// dates before 1970-01-01T00:00:00
				if fractions < 0 {
					fractions = Int(billion) + fractions
					t0 -= 1
				}
			} else {
				t0 += UInt64(epoch)
			}
			
			let tai_label = String( t0 , radix: 16 ).lowercased()
			let nano_label = String(fractions, radix: 16).lowercased()
			
			return "@" +
			String(repeating: "0", count: 16 - tai_label.count).appending(tai_label) +
			String(repeating: "0", count: 8 - nano_label.count).appending(nano_label)
		}
	}
}

public struct TAI64n {
	
}
