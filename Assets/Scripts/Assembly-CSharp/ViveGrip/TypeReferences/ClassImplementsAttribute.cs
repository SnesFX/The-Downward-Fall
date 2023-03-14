using System;

namespace ViveGrip.TypeReferences
{
	[AttributeUsage(AttributeTargets.Field, AllowMultiple = false)]
	public sealed class ClassImplementsAttribute : ClassTypeConstraintAttribute
	{
		public Type InterfaceType { get; private set; }

		public ClassImplementsAttribute()
		{
		}

		public ClassImplementsAttribute(Type interfaceType)
		{
			InterfaceType = interfaceType;
		}

		public override bool IsConstraintSatisfied(Type type)
		{
			if (base.IsConstraintSatisfied(type))
			{
				Type[] interfaces = type.GetInterfaces();
				foreach (Type type2 in interfaces)
				{
					if (type2 == InterfaceType)
					{
						return true;
					}
				}
			}
			return false;
		}
	}
}
