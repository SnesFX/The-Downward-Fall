using System;
using UnityEngine;

namespace ViveGrip.TypeReferences
{
	public abstract class ClassTypeConstraintAttribute : PropertyAttribute
	{
		private ClassGrouping _grouping = ClassGrouping.ByNamespaceFlat;

		private bool _allowAbstract;

		public ClassGrouping Grouping
		{
			get
			{
				return _grouping;
			}
			set
			{
				_grouping = value;
			}
		}

		public bool AllowAbstract
		{
			get
			{
				return _allowAbstract;
			}
			set
			{
				_allowAbstract = value;
			}
		}

		public virtual bool IsConstraintSatisfied(Type type)
		{
			return AllowAbstract || !type.IsAbstract;
		}
	}
}
