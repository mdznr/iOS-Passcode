//
//  NSLayoutConstraints+Multiple.h
//  Passcode
//
//  Created by Matt Zanchelli on 7/9/14.
//  Copyright (c) 2014 Matt Zanchelli. All rights reserved.
//

@import UIKit;

@interface NSLayoutConstraint (Multiple)

/// Create constraints described by ASCII art-like visual format strings.
/// @param formats An array of format specifications for the constraints.
/// @param opts Options describing the attribute and the direction of layout for all objects in the visual format string.
/// @param metrics A dictionary of constants that appear in the visual format string. The keys must be the string values used in the visual format string, and the values must be @c NSNumber objects.
/// @param views A dictionary of views that appear in the visual format string. The keys must be the string values used in the visual format string, and the values must be the view objects.
/// @return An array of constraints that, combined, express the constraints between the provided views and their parent view as described by the visual format string. The constraints are returned in the same order they were specified in the visual format string.
/// @discussion The language used for the visual format string is described in Visual Format Language in Auto Layout Guide.
+ (NSArray *)constraintsWithVisualFormats:(NSArray *)formats options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end
