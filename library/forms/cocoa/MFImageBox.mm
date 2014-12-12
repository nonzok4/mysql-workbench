/* 
 * Copyright (c) 2009, 2014, Oracle and/or its affiliates. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; version 2 of the
 * License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
 * 02110-1301  USA
 */

#import "MFImageBox.h"
#import "MFView.h"
#import "MFMForms.h"

#include "mforms/app.h"

@implementation MFImageBoxImpl

- (instancetype)initWithObject:(::mforms::ImageBox*)aImage
{
  self= [super initWithFrame:NSMakeRect(10,10,10,10)];
  if (self)
  {
    [self setImageFrameStyle: NSImageFrameNone];
    mOwner= aImage;
    mOwner->set_data(self);
    mScale= NO;
  }
  return self;
}

//--------------------------------------------------------------------------------------------------

- (mforms::Object*)mformsObject
{
  return mOwner;
}

- (NSSize)minimumSize
{
  if (!mScale)
    return [[self image] size];
  else
    return [super minimumSize];
}

static bool imagebox_create(mforms::ImageBox *image)
{
  [[[MFImageBoxImpl alloc] initWithObject:image] autorelease];
  
  return true;
}


static void imagebox_set_image(mforms::ImageBox *self, const std::string &file)
{
  if (self)
  {
    MFImageBoxImpl *impl= self->get_data();
    NSSize oldSize= [impl frame].size;
    
    std::string full_path= mforms::App::get()->get_resource_path(file);
    NSImage *image= [[[NSImage alloc] initWithContentsOfFile:wrap_nsstring(full_path)] autorelease];
    [impl setImage: image];

    if (!NSEqualSizes([image size], oldSize))
      [[impl superview] subviewMinimumSizeChanged];
  }
}


static void imagebox_set_image_data(mforms::ImageBox *self, const char *data, size_t length)
{
  if (self)
  {
    MFImageBoxImpl *impl= self->get_data();
    NSSize oldSize= [impl frame].size;
    
    NSImage *image= [[NSImage alloc] initWithData: [NSData dataWithBytes: (void*)data length: length]];
    if (![image isValid])
      throw std::invalid_argument("Invalid image data");

    [impl setImage: image];
    
    if (!NSEqualSizes([image size], oldSize))
      [[impl superview] subviewMinimumSizeChanged];
  }
}

static void imagebox_set_alignment(mforms::ImageBox *self, mforms::Alignment alignment)
{
  if (self)
  {
    MFImageBoxImpl *impl= self->get_data();
    switch (alignment)
    {
      case mforms::BottomLeft:
        [impl setImageAlignment: NSImageAlignBottomLeft];
        break;
      case mforms::MiddleLeft:
        [impl setImageAlignment: NSImageAlignLeft];
        break;
      case mforms::TopLeft:
        [impl setImageAlignment: NSImageAlignTopLeft];
        break;
      case mforms::BottomCenter:
        [impl setImageAlignment: NSImageAlignBottom];
        break;
      case mforms::TopCenter:
        [impl setImageAlignment: NSImageAlignTop];
        break;
      case mforms::MiddleCenter:
        [impl setImageAlignment: NSImageAlignCenter];
        break;
      case mforms::BottomRight:
        [impl setImageAlignment: NSImageAlignBottomRight];
        break;
      case mforms::MiddleRight:
        [impl setImageAlignment: NSImageAlignRight];
        break;
      case mforms::TopRight:
        [impl setImageAlignment: NSImageAlignTopRight];
        break;

      case mforms::NoAlign:
      case mforms::WizardLabelAlignment:
        break;
    }
  }  
}


static void imagebox_set_scale(mforms::ImageBox *self, bool flag)
{
  if (self)
  {
    MFImageBoxImpl *impl= self->get_data();
    impl->mScale= flag;
  }
}

void cf_imagebox_init()
{
  ::mforms::ControlFactory *f = ::mforms::ControlFactory::get_instance();
  
  f->_imagebox_impl.create= &imagebox_create;
  f->_imagebox_impl.set_image= &imagebox_set_image;
  f->_imagebox_impl.set_image_data= &imagebox_set_image_data;
  f->_imagebox_impl.set_image_align= &imagebox_set_alignment;
  f->_imagebox_impl.set_scale_contents= &imagebox_set_scale;
}

@end
