using System;

namespace ViveGrip.TypeReferences
{
	[AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
	public sealed class ClassExtendsAttribute : ClassTypeConstraintAttribute
	{
		public Type BaseType { get; private set; }

		public ClassExtendsAttribute()
		{
		}

		public ClassExtendsAttribute(Type baseType)
		{
			BaseType = baseType;
		}

		public override bool IsConstraintSatisfied(Type type)
		{
			return base.IsConstraintSatisfied(type) && BaseType.IsAssignableFrom(type) && type != BaseType;
		}
	}
}
